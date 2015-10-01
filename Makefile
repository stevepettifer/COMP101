ROOTINTRO=allintro
ROOTINTROSTAFF=${ROOTINTRO}-staff-version
ROOTINTROLARGE=${ROOTINTRO}-large
TEXINTRO=intro0.tex intro1.tex intro2.tex intro3.tex intro4.tex introappendix.tex

TEX=${TEXINTRO}

TEXINTRONOSUFF=${basename ${TEXINTRO}}
PDFINTRO=${addsuffix .pdf,${TEXINTRONOSUFF}}
PDFINTROLARGE=${addsuffix -large.pdf,${TEXINTRONOSUFF}}
PDFINTROSTAFF=${addsuffix -staff.pdf,${TEXINTRONOSUFF}}


PDF=${PDFINTRO} ${PDFINTROSTAFF} all-introlabs.pdf all-introlabs-staff.pdf

STY=${wildcard *.sty}

stu: stuintro
stuintro: all-introlabs.pdf ${PDFINTRO}

all: staff stu stularge

staff: staffintro
staffintro: all-introlabs-staff.pdf ${PDFINTROSTAFF}



large: stuintrolarge
stuintrolarge: all-introlabs-large.pdf ${PDFINTROLARGE}

all-introlabs.pdf: ${ROOTINTRO}.tex intro-body.tex ${TEXINTRO}  ${STY}
	echo > includes.tex
	pdflatex ${ROOTINTRO}; biber ${ROOTINTRO}; pdflatex ${ROOTINTRO}; pdflatex ${ROOTINTRO}; mv ${ROOTINTRO}.pdf $@

all-introlabs-large.pdf: ${ROOTINTROLARGE}.tex intro-body.tex ${TEXINTRO}  ${STY}
	echo > includes.tex
	pdflatex ${ROOTINTROLARGE}; biber ${ROOTINTROLARGE}; pdflatex ${ROOTINTROLARGE}; pdflatex ${ROOTINTROLARGE}; mv ${ROOTINTROLARGE}.pdf $@

all-introlabs-staff.pdf: ${ROOTINTRO}.tex intro-body.tex ${TEXINTRO}  ${STY}
	echo > includes.tex
	pdflatex ${ROOTINTROSTAFF}; biber ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF}; mv ${ROOTINTROSTAFF}.pdf $@


intro%-staff.pdf: intro%.tex ${ROOTINTROSTAFF}.tex ${STY}
	echo '\includeonly{'intro$*'}' > includes.tex
	pdflatex ${ROOTINTROSTAFF} ; biber ${ROOTINTROSTAFF}; pdflatex ${ROOTINTROSTAFF} ; pdflatex ${ROOTINTROSTAFF} ; mv ${ROOTINTROSTAFF}.pdf $@

intro%-large.pdf: intro%.tex ${ROOTINTROLARGE}.tex ${STY}
	echo '\includeonly{'intro$*'}' > includes.tex
	pdflatex ${ROOTINTROLARGE} ; biber ${ROOTINTROLARGE}; pdflatex ${ROOTINTROLARGE} ; pdflatex ${ROOTINTROLARGE} ; mv ${ROOTINTROLARGE}.pdf $@

intro%.pdf: intro%.tex ${ROOTINTRO}.tex ${STY}
	echo '\includeonly{'intro$*'}' > includes.tex
	pdflatex ${ROOTINTRO} ; biber ${ROOTINTRO}; pdflatex ${ROOTINTRO} ; pdflatex ${ROOTINTRO} ; mv ${ROOTINTRO}.pdf $@

allintro: all-introlabs-staff.pdf  all-introlabs.pdf ${PDFINTRO} ${PDFINTROSTAFF} 

clean:
	rm -f ${ROOT}.pdf  ${ROOTINTRO}.pdf  ${ROOTINTROSTAFF}.pdf ${PDF} ${PDFSTAFF} *.aux *.log *.mtc* *.maf *.rel *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf comment.cut

minitoc:	
	./remake ${PDF} 

minitocsv:	
	./remake ${PDFSTAFF} 
