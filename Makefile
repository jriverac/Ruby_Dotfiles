compare:
	ksdiff ~/.railsrc ~/Code/Ruby/Dotfiles/.railsrc;

install:
	if [ diff ~/.railsrc ~/Code/Ruby/Dotfiles/.railsrc ]; then \
		echo "Files are the same"; \
	fi

deploy:
	cp ~/.railsrc ~/Code/Ruby/Dotfiles/.railsrc;
