ROOT=labs
TEX=rpi1.tex rpi2.tex
TEXNOSUFF=${basename ${TEX}}
PDF=${addsuffix .pdf,${TEXNOSUFF}}

default: ${PDF}

${ROOT}.pdf: ${ROOT}.tex ${TEX}
	pdflatex ${ROOT}; biber ${ROOT}; pdflatex ${ROOT}


%.pdf: %.tex ${ROOT}.tex includes.tex
	echo '\includeonly{'$*'}' > includes.tex
	pdflatex ${ROOT} ; biber ${ROOT}; pdflatex ${ROOT} ;mv ${ROOT}.pdf $@

all: ${PDF}

clean:
	rm -f ${ROOT}.pdf ${PDF} *.aux *.log *.bbl *.toc *.out *.run.xml *.out *.blg *.bcf

