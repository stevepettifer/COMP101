#!/usr/bin/env python

#
# Monitors ethernet port, logs MAC and generates and logs sequence numbers of
# all slave Pi's connected to this host Pi (Master Pi) via direct ethernet.
#
# This script runs from the host Pi (Master Pi). This Pi is intended to be used
#  for the purpose of logging repeatedly, but any Pi can be used if the log file
#  is preserved and the Pi fulfils the requirements (below)
# 
# Run this script specifying the year with -y
# For more info use -h
#
# Requirements: Full installation of scapy, and root privileges, also:
# SD Card on the Pi this is run from(Master Pi) should statically assign itself
#  an IP address. SD Card on slave Pi should statically assign itself the IP
#  address 192.168.0.2 (or modify code below to suit, line 115:
#   ans,unans=srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst="192.168.0.2"), timeout=2)  )
#
# Picks up where it left off when run again with valid log file. Finds latest
#  sequence for specified year from log file maclog.log
#
# Hamza Mahmud, 16th August 2013
#

import sys, getopt, time
from scapy.all import srp,Ether,ARP,conf

# If the string already exists in any line of the open file, returns False
def check_string(string, f):
	f.seek(0, 0)	# to start of file to search the whole file
	for line in f:
		if string == line.split(",")[0]:
			print 'Error: MAC already logged with sequence: ' + line.split(",")[1]
			f.seek(0, 2) # seek to end of file for next write
			return False
	return True # seek is at end of file

# Prints help
def help():
	print ' ------------------------------------------------------------------------------'
	print ' Raspberry Pi MAC/sequence logging script'
	print ' Hamza Mahmud (mahmudm0@cs.man.ac.uk) Aug 2013'
	print ' '
	print ' Log MAC / generated sequence number for every unique Pi connected to eth0'
	print ' MUST BE RUN WITH ROOT PRIVELIGES, requires Scapy, requires static IP addresses'
	print ' Sequence number format yy/xxxx, yy is academic year, xxxx is unique ID'
	print ' Example output: aa:bb:cc:dd:ee:ff,13/0001'
	print ' '
	print ' Resumes sequence on every start by reading log file to find last used sequence'
	print ' '
	print ' Typical usage:'
	print ' sudo python maclog.py -y 13'
	print ' '
	print ' -y Sequence year (first two digits in sequence number before the slash)'
	print ' '
	print ' ------------------------------------------------------------------------------'

# Prints short usage info
def usage():
	print 'usage: maclog.py -y <sequenceyear>'
	print 'Must run as root, sequenceyear = 2 digit year code e.g. 13 for 2013'
	print 'for more info: maclog.py -h'	


def main(argv):
	try:	# opts is option/value pairs, args is the rest of the args
		opts, args = getopt.getopt(argv,"hy:",["year="])
	except getopt.GetoptError:
		usage()
		sys.exit(2)

	# -y year must be provided if -h isn't specified. Otherwise will exit.
	if len(opts) == 0:
		usage()
		sys.exit()		
	for opt, arg in opts:
		if opt in ("-h", "--help"):
			help()
			sys.exit()
		elif opt in ("-y", "--year"):
			year = int(arg)
		else:
			usage()
			sys.exit()

	# check if log file exists, ask to make new one if not.
	try:
		with open('maclog.log'): pass
	except IOError:
		print "Cannot find log file 'maclog.log', create empty log file?"
		print "Creating an empty log file will reset sequence to 0000"
		ans = raw_input('Type "y", return to create empty log file, any other key to exit: ')
		if ans == "y":
			# create log file
			f = open('maclog.log', 'w')
			f.write('')
			f.close
			print "Empty 'maclog.log' created"
		else:
			print 'Exiting'
			sys.exit()

	# Open the log file. If 
	try:	
		f = open('maclog.log', 'r+')
	except IOError:
		print "Unable to open log file 'maclog.log', probably access denied error"
		print "If this persists either restart this Pi, or copy important data out of log file and delete it, then run this script again."
		print 'Data can be copied back after new file is made'
		sys.exit()

	# find out where we left off so we can correctly generate next sequence num
	# basically reads through log file finding highest seq num for this year.
	nextseq = 0
	f.seek(0, 0) # start reading from start
	for line in f:
		# only if it's this year, and the seq is ahead of current seq (shouldn't happen but just in case)
		fullseq = (line.split(",")[-1]).split("/")
		if int(fullseq[0]) == year and int(fullseq[1]) > nextseq:
			nextseq=int(fullseq[1])	# get sequence number of string
	f.seek(0, 0) # seek back to start for subsequent access
	nextseq+=1
	print "Ready, awaiting Pi connection. To exit press Ctrl+C"
	print "Note: Raspberry Pi's take a few minutes to boot up once switched on"
	print " "
	conf.verb=0
	previousmac="random"
	mac="random"	# something equal to previousmac
	try:
		while True:
			# try and get a mac address
			try:
				ans,unans=srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst="192.168.0.2"), timeout=2)
			except:
				z = 1 # i.e. do nothing. this catches if the power is disconnected before ethernet
			
			for snd,rcv in ans:
				# if no device connected mac will not change from previous
				mac=rcv.sprintf("%Ether.src%") 
			# process the gotten mac address
			# if new mac found (i.e. new device has been connected)
			if previousmac != mac:	
				print "Pi detected. Processing mac address: " + mac
				previousmac=mac
				# check if this mac address has already been assigned
				if check_string(mac, f): # will always have seek position at end of file
					finalLine = "{0},{1}/{2:04d}".format(mac,year,nextseq)
					print "Unique MAC logged with sequence: " + "{0:02d}/{1:04d}".format(year,nextseq)
					print finalLine					
					f.write(finalLine + "\n")
					print "Safe to remove Pi, awaiting next.."
					nextseq += 1
				else:
					print "MAC already exists, not logged"
					print "Safe to remove Pi, awaiting next.."
				print " "
			# wait 5 seconds before iterating while loop again.
			time.sleep(5)
	except KeyboardInterrupt:
		# Ensure log file is closed on exit.
		print "Closing log file and exiting..."
		print " "
		f.close()
		sys.exit()

main(sys.argv[1:])
