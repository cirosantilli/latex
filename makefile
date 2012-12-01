#inputs
CC=pdflatex
IN_EXT=.tex
AUX_DIR=_aux/
OUT_DIR=_out/
OUT_EXT=.pdf
#end inputs

INS=$(wildcard *$(IN_EXT))
OUTS_NODIR=$(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS))
OUTS=$(addprefix $(OUT_DIR),$(OUTS_NODIR))

.PHONY: all mkdir clean

all: mkdir $(OUTS)

$(OUT_DIR)%$(OUT_EXT): %$(IN_EXT)

	# make pdf with bibtex and synctex
	$(CC) -output-directory "$(AUX_DIR)" "$*"
	-bibtex "$(AUX_DIR)$*" #allowing for error here in case tex has no bib files
	$(CC) -interaction=nonstopmode -output-directory "$(AUX_DIR)" "$*"
	$(CC) -interaction=nonstopmode -output-directory "$(AUX_DIR)" -synctex=1 "$*"

	#move output to out dir
	-mv -f $(AUX_DIR)$*$(OUT_EXT) "$(OUT_DIR)"

mkdir:
	mkdir -p "$(AUX_DIR)"
	mkdir -p "$(OUT_DIR)"

clean:
	@rm -rf $(OUT_DIR) $(AUX_DIR)
