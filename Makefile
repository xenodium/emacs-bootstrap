all: init

init:
	mkdir -p ~/.emacs.d
	python copy_into.py init.el ~/.emacs.d/init.el "my-emacs" ";;"
	make -C features
