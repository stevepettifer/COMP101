(TeX-add-style-hook "rpi1"
 (lambda ()
    (LaTeX-add-labels
     "figure:bare-rpi"
     "figure:bare-rpi-underside"
     "figure:monitorswitch"
     "bootbox"
     "figure:raspi-config"
     "figure:piboot"
     "figure:prompt"
     "figure:xkcd-password"
     "figure:simple-navigation"
     "figure:cern-pdp-10"
     "section:shutdown"
     "table-dirs")
    (TeX-run-style-hooks
     "./startuptext")))

