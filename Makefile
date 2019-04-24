
all:
	latexmk -pdf -bibtex -g -pdflatex="pdflatex -interaction=nonstopmode -shell-escape '\def\thesis{} \input{phd-thesis.tex}'" phd-thesis.tex