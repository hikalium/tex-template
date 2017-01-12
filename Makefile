.PHONY: report.tex

default:
	make report.pdf
	open report.pdf

%.png : %.gnp Makefile
	gnuplot -c $*.gnp
	gs -sDEVICE=pngmono -dEPSCrop -r1024 -o $*.png $*.eps

%.dvi : %.tex Makefile
	platex $*.tex

%.pdf : %.dvi Makefile
	dvipdfmx $*
