
thesis:
	latexmk -synctex=1 -interaction=nonstopmode -shell-escape -pdf -file-line-error -bibtex phd-thesis.tex

all:
	latexmk -pdf -bibtex -g -pdflatex="pdflatex -interaction=nonstopmode -shell-escape '\def\thesis{} \input{phd-thesis.tex}'" phd-thesis.tex
