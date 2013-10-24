ROOT101=all101
ROOT101STAFF=${ROOT101}-staff-version
TEX101=101lab1.tex 101lab2.tex 101lab3.tex 101lab4.tex

TEX=${TEX101}

TEX101NOSUFF=${basename ${TEX101}}
PDF101=${addsuffix .pdf,${TEX101NOSUFF}}
PDF101STAFF=${addsuffix -staff.pdf,${TEX101NOSUFF}}


PDF=${PDF101} ${PDF101STAFF} all-101labs.pdf  all-101labs-staff.pdf

STY=${wildcard *.sty}

all: staff stu

staff: staff101
staff101: all-101labs-staff.pdf ${PDF101STAFF}


stu: stu101
stu101: all-101labs.pdf ${PDF101}


all-101labs.pdf: ${ROOT101}.tex ${TEX101}  ${STY}
	echo > includes.tex
	pdflatex ${ROOT101}; biber ${ROOT101}; pdflatex ${ROOT101}; pdflatex ${ROOT101}; mv ${ROOT101}.pdf $@

all-101labs-staff.pdf: ${ROOT101}.tex ${TEX101}  ${STY}
	echo > includes.tex
	pdflatex ${ROOT101STAFF}; biber ${ROOT101STAFF}; pdflatex ${ROOT101STAFF}; pdflatex ${ROOT101STAFF}; mv ${ROOT101STAFF}.pdf $@


101%-staff.pdf: 101%.tex ${ROOT101STAFF}.tex ${STY}
	echo '\includeonly{'101$*'}' > includes.tex
	pdflatex ${ROOT101STAFF} ; biber ${ROOT101STAFF}; pdflatex ${ROOT101STAFF} ; pdflatex ${ROOT101STAFF} ; mv ${ROOT101STAFF}.pdf $@

101%.pdf: 101%.tex ${ROOT101}.tex ${STY}
	echo '\includeonly{'101$*'}' > includes.tex
	pdflatex ${ROOT101} ; biber ${ROOT101}; pdflatex ${ROOT101} ; pdflatex ${ROOT101} ; mv ${ROOT101}.pdf $@


clean:
	rm -f 101labs.pdf ${ROOT}.pdf ${PDF} ${PDFSTAFF} *.aux *.log *.mtc* *.maf *.rel *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf comment.cut

minitoc:	
	./remake ${PDF} 

minitocsv:	
	./remake ${PDFSTAFF} 
