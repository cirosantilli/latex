#compiles all tex files in current dir as pdfs

#may take input from any dir, and put output in any dir.
#note however that some programs like synctex are quite fussy about not using current dir.

	#extension of input files:
override IN_EXT   	?= .tex
	#directory from which input files come. slash termianted:
override IN_DIR   	?= ./

	#dir where auxiliary files such as `.out` will be put. slash terminated:
override AUX_DIR  	?= _aux/
	#dir where output files such as .pdf will be put. slash terminated:
override OUT_DIR  	?= _out/
	#extension of output:
override OUT_EXT 		?= .pdf

	#basename without extension of file to run:
override VIEW				?= cheat
	#initial page on view (begs to be overriden with vim command):
override VIEW_LINE	?= 1
	#viewer command used to view the output:
override VIEWER 		?= okular --unique

	#compile command
override CCC 				?= pdflatex -interaction=nonstopmode -output-directory "$(AUX_DIR)" 

INS					:= $(wildcard $(IN_DIR)*$(IN_EXT))
INS_NODIR		:= $(notdir $(INS))
OUTS_NODIR	:= $(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS_NODIR))
OUTS				:= $(addprefix $(OUT_DIR),$(OUTS_NODIR))

STYS				:= $(wildcard $(IN_DIR)*.sty)
BIBS				:= $(wildcard $(IN_DIR)*.bib)

	#path of tex file to be viewed (needed by synctex):
VIEW_TEX_PATH	:= $(IN_DIR)$(VIEW)$(IN_EXT)
	#path of output file to be viewed:
VIEW_OUT_PATH	:= $(OUT_DIR)$(VIEW)$(OUT_EXT)

#remove automatic rules:
.SUFFIXES:

.PHONY: all clean help mkdir run ubuntu_install

all: mkdir $(OUTS)

	#$(STYS) $(BIBS) are here so that if any include files are modified, make again:
$(OUT_DIR)%$(OUT_EXT): $(IN_DIR)%$(IN_EXT) $(STYS) $(BIBS)
	# make pdf with bibtex and synctex:
	$(CCC) "$<"
	#allowing for error here in case tex has no bib files:
	-bibtex "$(AUX_DIR)$*"
	$(CCC) "$<"
	$(CCC) -synctex=1 "$<"
	#move output to out dir:
	-mv -f $(AUX_DIR)$*$(OUT_EXT) "$(OUT_DIR)"

#removes the aux and out dirs
#also removes all files with known output extensions
#in case you and to clean after using some ide
#that does not allow for subdirs
clean:
	rm -rf $(OUT_DIR) $(AUX_DIR) \
		*.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg \
		*.dvi *.glg *.gls *.ilg *.ind *.lof *.lot *.maf *.mtc *.mtc1 *.out \
		*.synctex.gz *.ps *.pdf

help:
	@echo 'sample invocations:'
	@echo '  #installs dependencies on Ubuntu'
	@echo '    ubuntu_install_deps'
	@echo '    make'
	@echo '    make clean'
	@echo '  #views the default output file with our default view command'
	@echo '    make run'
	@echo '  #view another file:'
	@echo '    make run VIEW=main'
	@echo '  #will view file main$$(OUT_EXT)'
	@#TODO manage page to allow this:
	@#echo '  #views given file with given command:'
	@#echo "    make run VIEWER='\"evince -f\"'"

mkdir:
	mkdir -p "$(AUX_DIR)"
	mkdir -p "$(OUT_DIR)"

#view output.
#called `run` for compatibility with makefiles that make executables.
#TODO: get synctex to work!!!
#SYNCTEX_OUT="`synctex view -i "$(VIEW_LINE):1:$(VIEW_TEX_PATH)" -o "$(VIEW_OUT_PATH)" -d "$(AUX_DIR)"`" ;\
#PDF_PAGE="`echo "$$SYNCTEX_OUT" | awk -F: '$$1 ~/Page/ { print $$2; exit }'`" ;\
#echo $$PDF_PAGE ;
run: all
	( \
		PDF_PAGE=1 ;\
		nohup $(VIEWER) -p "$$PDF_PAGE" $(VIEW_OUT_PATH) >/dev/null & \
	)

ubuntu_install_deps:
	sudo aptitude install -y texlive-full
	sudo aptitude install -y okular
