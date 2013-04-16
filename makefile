#compiles all tex files in current dir as pdfs

#may take input from any dir, and put output in any dir.
#note however that some programs like synctex are quite fussy about not using current dir.

CC=pdflatex				#compile command
IN_EXT=.tex				#extension of input files
IN_DIR=./					#directory from which input files come. slash termianted.
AUX_DIR=_aux/			#dir where auxiliary files such as `.out` will be put. slash terminated.
OUT_DIR=_out/			#dir where output files such as .pdf will be put. slash terminated.
OUT_EXT=.pdf			#extension of output

INS=$(wildcard $(IN_DIR)*$(IN_EXT))
INS_NODIR=$(notdir $(INS))
OUTS_NODIR=$(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS_NODIR))
OUTS=$(addprefix $(OUT_DIR),$(OUTS_NODIR))

.PHONY: all mkdir clean

all: mkdir $(OUTS)

$(OUT_DIR)%$(OUT_EXT): $(IN_DIR)%$(IN_EXT)

	# make pdf with bibtex and synctex
	$(CC) -output-directory "$(AUX_DIR)" "$<"
	-bibtex "$(AUX_DIR)$*" #allowing for error here in case tex has no bib files
	$(CC) -interaction=nonstopmode -output-directory "$(AUX_DIR)" "$<"
	$(CC) -interaction=nonstopmode -output-directory "$(AUX_DIR)" -synctex=1 "$<"

	#move output to out dir
	-mv -f $(AUX_DIR)$*$(OUT_EXT) "$(OUT_DIR)"

mkdir:
	mkdir -p "$(AUX_DIR)"
	mkdir -p "$(OUT_DIR)"

#removes the output dirs, and also all files with known output extensions
clean:
	rm -rf $(OUT_DIR) $(AUX_DIR) \
		*.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg \
		*.dvi *.glg *.gls *.ilg *.ind *.lof *.lot *.maf *.mtc *.mtc1 *.out \
		*.synctex.gz *.ps *.pdf
