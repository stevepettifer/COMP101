(TeX-add-style-hook "101labs"
 (lambda ()
    (LaTeX-add-environments
     "ttoutenv")
    (TeX-add-symbols
     '("wikipedia" 2)
     '("circled" 1)
     '("fname" 1)
     '("ttout" 1)
     '("totype" 1)
     "tinsy")
    (TeX-run-style-hooks
     "biblatex"
     "tikz"
     "placeins"
     "breakbox"
     "lipsum"
     "textcomp"
     "handout"
     "a4-mancs"
     "listings"
     "color"
     "hyperref"
     "url"
     "palatino"
     "alltt"
     "array"
     "graphicx")))

