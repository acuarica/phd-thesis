
thesis:
	latexmk -synctex=1 -interaction=nonstopmode -shell-escape -pdf -bibtex phd-thesis.tex
	cp phd-thesis.pdf public/

all:
	latexmk -pdf -bibtex -g -pdflatex="pdflatex -interaction=nonstopmode -shell-escape '\def\thesis{} \input{phd-thesis.tex}'" phd-thesis.tex

clean:
	latexmk -C