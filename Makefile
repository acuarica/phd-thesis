
all:
	latexmk -pdf -bibtex -interaction=nonstopmode -shell-escape -g phd-thesis.tex
	cp phd-thesis.pdf public/

clean:
	latexmk -C