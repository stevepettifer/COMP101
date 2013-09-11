ROOT=labs
TEX=welcome.tex rpi1.tex desktop1.tex rpi2.tex desktop2.tex desktop3.tex desktop4.tex latex-exercise.tex desktop5.tex appendix.tex
TEXNOSUFF=${basename ${TEX}}
PDF=${addsuffix .pdf,${TEXNOSUFF}}
STY=${wildcard *.sty}

default: ${PDF}

101labs.pdf: ${ROOT}.tex ${TEX} ${STY}
	echo > includes.tex
	pdflatex ${ROOT}; biber ${ROOT}; pdflatex ${ROOT}; pdflatex ${ROOT}; mv ${ROOT}.pdf $@


%.pdf: %.tex ${ROOT}.tex ${STY}
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOT} ; biber ${ROOT}; pdflatex ${ROOT} ; pdflatex ${ROOT} ; mv ${ROOT}.pdf $@

all: ${PDF} 101labs.pdf

clean:
	rm -f 101labs.pdf ${ROOT}.pdf ${PDF} *.aux *.log *.mtc* *.maf *.rel *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf comment.cut

