.PHONY: %.tex %.dvi	%.tex
PREAMBLE_FILE=style/preamble.tex
OUT_DIR = ./out

default:
	make report.pdf
	open -a Skim -g report.pdf
	#open report.pdf

%.tex : %.md Makefile
	pandoc $*.md \
		-o $(OUT_DIR)/$*.tex

%.png : %.gnp Makefile
	gnuplot -c $*.gnp
	gs -sDEVICE=pngmono -dEPSCrop -r1024 -o $*.png $*.eps

$(OUT_DIR)/%.dvi : $(OUT_DIR)/%.tex $(PREAMBLE_FILE) Makefile
	platex -halt-on-error \
		-output-directory=$(OUT_DIR) \
		-jobname=$* \
		$(PREAMBLE_FILE) \
		"\begin{document}" \
		"\input{$(OUT_DIR)/$*.tex}" \
		"\end{document}"

$(OUT_DIR)/%.dvi : %.tex $(PREAMBLE_FILE) Makefile
	platex -halt-on-error \
		-output-directory=$(OUT_DIR) \
		-jobname=$* \
		$(PREAMBLE_FILE) \
		"\begin{document}" \
		"\input{$*.tex}" \
		"\end{document}"

%.pdf : $(OUT_DIR)/%.dvi Makefile
	dvipdfmx $(OUT_DIR)/$*.dvi
