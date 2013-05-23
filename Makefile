ROOT=labs
TEX=rpi1.tex rpi2.tex
TEXNOSUFF=${basename ${TEX}}
PDF=${addsuffix .pdf,${TEXNOSUFF}}
STY=${wildcard *.sty}

default: ${PDF}

101labs.pdf: ${ROOT}.tex ${TEX} ${STY}
	echo > includes.tex
	pdflatex ${ROOT}; biber ${ROOT}; pdflatex ${ROOT};mv ${ROOT}.pdf $@


%.pdf: %.tex ${ROOT}.tex includes.tex ${STY}
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOT} ; biber ${ROOT}; pdflatex ${ROOT} ;mv ${ROOT}.pdf $@

all: ${PDF} 101labs.pdf

clean:
	rm -f 101labs.pdf ${ROOT}.pdf ${PDF} *.aux *.log *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf

