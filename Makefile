
all:
	latexmk -pdf -bibtex -g -interaction=nonstopmode -shell-escape phd-thesis.tex
	cp phd-thesis.pdf public/

clean:
	latexmk -C
