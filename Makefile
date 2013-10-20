ROOT=labs
ROOTSV=labs-staff-version
TEX=welcome.tex rpi1.tex desktop1.tex rpi2.tex desktop2.tex desktop3.tex desktop4.tex latex.tex desktop5.tex appendix.tex
TEXNOSUFF=${basename ${TEX}}
PDF=${addsuffix .pdf,${TEXNOSUFF}}
PDFSV=${addsuffix -staff.pdf,${TEXNOSUFF}}
STY=${wildcard *.sty}

staff: 101labs-staff.pdf ${PDFSV}

stu: ${PDF}

101labs.pdf: ${ROOT}.tex ${TEX} git.tex ${STY}
	echo > includes.tex
	pdflatex ${ROOT}; biber ${ROOT}; pdflatex ${ROOT}; pdflatex ${ROOT}; mv ${ROOT}.pdf $@


101labs-staff.pdf: ${ROOTSV}.tex git.tex ${TEX} ${STY}
	echo > includes.tex
	pdflatex ${ROOTSV}; biber ${ROOTSV}; pdflatex ${ROOTSV}; pdflatex ${ROOTSV}; mv ${ROOTSV}.pdf $@


%-staff.pdf: %.tex ${ROOTSV}.tex ${STY}
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOTSV} ; biber ${ROOTSV}; pdflatex ${ROOTSV} ; pdflatex ${ROOTSV} ; mv ${ROOTSV}.pdf $@

%.pdf: %.tex ${ROOT}.tex ${STY}
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOT} ; biber ${ROOT}; pdflatex ${ROOT} ; pdflatex ${ROOT} ; mv ${ROOT}.pdf $@

all: 101labs.pdf  ${PDF} 101labs-staff.pdf ${PDFSV} 

clean:
	rm -f 101labs.pdf ${ROOT}.pdf ${PDF} *.aux *.log *.mtc* *.maf *.rel *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf comment.cut

minitoc:	
	./remake ${PDF} 

minitocsv:	
	./remake ${PDFSV} 
