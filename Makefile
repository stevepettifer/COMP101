ROOTINTRO=allintro
ROOTINTROSTAFF=${ROOTINTRO}-staff-version
TEXINTRO=intro0.tex intro1.tex intro2.tex intro3.tex intro4.tex

ROOT101=all101
ROOT101STAFF=${ROOT101}-staff-version
TEX101=101lab1.tex 101lab2.tex 101lab3.tex 101lab4.tex 101appendix.tex

TEX=${TEXINTRO} ${TEX101}

TEXINTRONOSUFF=${basename ${TEXINTRO}}
PDFINTRO=${addsuffix .pdf,${TEXINTRONOSUFF}}
PDFINTROSTAFF=${addsuffix -staff.pdf,${TEXINTRONOSUFF}}

TEX101NOSUFF=${basename ${TEX101}}
PDF101=${addsuffix .pdf,${TEX101NOSUFF}}
PDF101STAFF=${addsuffix -staff.pdf,${TEX101NOSUFF}}


PDF=${PDFINTRO} ${PDFINTROSTAFF} ${PDF101} ${PDF101STAFF} 

STY=${wildcard *.sty}

all: staff stu

staff: staffintro staff101
staffintro: all-introlabs-staff.pdf ${PDFINTROSTAFF}
staff101: all-101labs-staff.pdf ${PDF101STAFF}


stu: stuintro stu101
stuintro: ${PDFINTRO}
stu101: ${PDF101}

all-introlabs.pdf: ${ROOTINTRO}.tex ${TEXINTRO}  ${STY}
	echo > includes.tex
	pdflatex ${ROOTINTRO}; biber ${ROOTINTRO}; pdflatex ${ROOTINTRO}; pdflatex ${ROOTINTRO}; mv ${ROOTINTRO}.pdf $@

all-introlabs-staff.pdf: ${ROOTINTRO}.tex ${TEXINTRO}  ${STY}
	echo > includes.tex
	pdflatex ${ROOTINTROSTAFF}; biber ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF}; mv ${ROOTINTROSTAFF}.pdf $@

all-101labs.pdf: ${ROOT101}.tex ${TEX101}  ${STY}
	echo > includes.tex
	pdflatex ${ROOT101}; biber ${ROOT101}; pdflatex ${ROOT101}; pdflatex ${ROOT101}; mv ${ROOT101}.pdf $@

all-101labs-staff.pdf: ${ROOT101}.tex ${TEX101}  ${STY}
	echo > includes.tex
	pdflatex ${ROOT101STAFF}; biber ${ROOT101STAFF}; pdflatex ${ROOT101STAFF}; pdflatex ${ROOT101STAFF}; mv ${ROOT101STAFF}.pdf $@


intro%-staff.pdf: intro%.tex ${ROOTINTROSTAFF}.tex ${STY}
	echo '\includeonly{'intro$*'}' > includes.tex
	pdflatex ${ROOTINTROSTAFF} ; biber ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF} ; pdflatex ${ROOTINTROSTAFF} ; mv ${ROOTINTROSTAFF}.pdf $@

101%-staff.pdf: 101%.tex ${ROOT101STAFF}.tex ${STY}
	echo '\includeonly{'101$*'}' > includes.tex
	pdflatex ${ROOT101STAFF} ; biber ${ROOT101STAFF}; pdflatex ${ROOT101STAFF} ; pdflatex ${ROOT101STAFF} ; mv ${ROOT101STAFF}.pdf $@

intro%.pdf: intro%.tex ${ROOTINTRO}.tex ${STY}
	echo '\includeonly{'intro$*'}' > includes.tex
	pdflatex ${ROOTINTRO} ; biber ${ROOTINTRO}; pdflatex ${ROOTINTRO} ; pdflatex ${ROOTINTRO} ; mv ${ROOTINTRO}.pdf $@

101%.pdf: 101%.tex ${ROOT101}.tex ${STY}
	echo '\includeonly{'101$*'}' > includes.tex
	pdflatex ${ROOT101} ; biber ${ROOT101}; pdflatex ${ROOT101} ; pdflatex ${ROOT101} ; mv ${ROOT101}.pdf $@


%.pdf: %.tex ${ROOT}.tex ${STY}
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOT} ; biber ${ROOT}; pdflatex ${ROOT} ; pdflatex ${ROOT} ; mv ${ROOT}.pdf $@

all101: all-101labs-staff.pdf  all-101labs.pdf ${PDF101} ${PDF101STAFF} 

allintro: all-introlabs-staff.pdf  all-introlabs.pdf ${PDFINTRO} ${PDFINTROSTAFF} 

clean:
	rm -f 101labs.pdf ${ROOT}.pdf ${PDF} ${PDFSTAFF} *.aux *.log *.mtc* *.maf *.rel *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf comment.cut

minitoc:	
	./remake ${PDF} 

minitocsv:	
	./remake ${PDFSTAFF} 
