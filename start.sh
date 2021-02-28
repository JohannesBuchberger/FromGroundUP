#/bin/bash

userInput=''
expectUserInput()
{
	# programming check - make sure a description is provided to the user
	# since the user needs to know what to agree/decline to
	if [ -z "$1" ]; then
		echo 'provide input description'
		exit 128
	fi

	# print description
    echo "##############################################################"
	echo "#  $1?  #"
    echo "##############################################################"
	# expect feedback from the user (yes or not)
	read -p 'Confirm or skip this step? (y/n)' response

	if [ $response = 'y' ] || [ $response = 'Y'  ]; then
		userInput='y'
	elif [ $response = 'n' ] || [ $response = 'N' ]; then
		userInput='n'
	else 
		# in case the user doesn't answer with y or n just repeat the scenario
		echo 'expect y or n'
		expectUserInput "$1"
	fi
}
DIR="$(dirname "$(readlink -f "$0")")"
ABSOLUTE_CONFIG_PATH=$DIR/configs/

################################
# update package manager (UPM) 
################################
sudo apt update -y
expectUserInput 'upgrade apt'
if [ $userInput == 'y' ]; then
	sudo apt -y upgrade
fi

################################
# ZSH
# Requires: UPM
################################
expectUserInput 'install zsh'
if [ $userInput == 'y' ]; then
	sudo apt install -y zsh
	# change terminal to zsh
	chsh -s $(which zsh) 
	# copy config after installation of oh-my-zsh
fi

################################
# TMUX
# Requires: UPM
# Requires: ZSH (opt)
################################
expectUserInput 'install tmux'
if [ $userInput == 'y' ]; then
	sudo apt install -y tmux
	ln -s $ABSOLUTE_CONFIG_PATH.tmux.conf ~/
fi

################################
# VIM
# Requires: UPM
################################
expectUserInput 'install vim (+plugins)'
if [ $userInput == 'y' ]; then
	sudo apt install -y vim
	ln -s $ABSOLUTE_CONFIG_PATH.vimrc ~/
	echo 'the following few steps might take some time, thats normal'
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

fi

################################
# GIT
# Requires: UPM
################################
expectUserInput 'Install git (and git-config)'
if [ $userInput == 'y' ]; then
	sudo apt install -y git
	ln -s $ABSOLUTE_CONFIG_PATH.gitconfig ~/
fi

################################
# NPM
# Requires: UPM
################################
expectUserInput 'Install Node-Package-Manager (NPM) (required for git-plugin diff-so-fancy)'
if [ $userInput == 'y' ]; then
	sudo apt install -y npm
	
    ################################
    # diff-so-fancy
    # Requires: NPM
    # Requires: GIT
    ################################
	expectUserInput 'Install Git-plugin: diff-so-fancy'
	if [ $userInput == 'y' ] || [ $userInput = 'Y' ]; then
		sudo npm install -g diff-so-fancy
		git diff --color | diff-so-fancy
	fi
fi


################################
# Maven
# Requires: UPM
################################
expectUserInput 'Install maven'
if [ $userInput == 'y' ]; then
	sudo apt install -y maven

	expectUserInput 'Install maven specific settings.xml (exentra specific)'
	if [ $userInput == 'y' ]; then
		echo 'this functionality is currently unavailable - should copy a settings.xml into ~/.m2/'
	fi
fi

################################
# CURL
# Requires: UPM
################################
expectUserInput 'Install curl (Required for docker and oh-my-zsh)'
if [ $userInput == 'y' ]; then
	sudo apt install curl
	
    ################################
	# DOCKER
	# Requires: UPM
	# Requires: CURL
    ################################
	expectUserInput 'Install docker'
	if [ $userInput == 'y' ]; then
		# see install docker engine on docs.docker.com for more info
		sudo apt install -y \
			apt-transport-https \
			ca-certificates \
			curl \
			gnupg-agent \
			software-properties-common
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository \
			"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		sudo apt update
		sudo apt install -y docker-ce docker-ce-cli containerd.io
		apt-cache madison docker-ce
		read -p 'enter the docker version' dockerVersion
		sudo apt install -y docker-ce=$dockerVersion docker-ce-cli=$dockerVersion containerd.io

		#Install docker-compose
		sudo curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	fi
	
    ################################
	# OHMYZSH
	# Requires: UPM
	# Requires: GIT
	# Requires: CURL
	# Requires: ZSH
    ################################
	expectUserInput 'Install Oh-My-Zsh? (requires zsh)'
	if [ $userInput == 'y' ]; then
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		git clone https://github.com/powerline/fonts.git --depth=1
		cd fonts
		./install.sh
		cd ..
		rm -rf fonts
	fi

    ################################
	# P10K
	# Requires: GIT
	# Requires: OHMYZSH
    ################################
    read -p 'What should be the directory to oh-my-zsh (default: ~/.oh-my-zsh)' ZSH_CUSTOM
    if [ -z $ZSH_CUSTOM ]; then
        ZSH_CUSTOM=~/.oh-my-zsh
    fi

	expectUserInput 'Install powerlevel10k (design-theme) for the terminal alongside oh-my-zsh'
    if [ $userInput == 'y' ]; then
	    	sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
	fi
	
    ################################
    # ZSH-PLUGINS
	# Requires: UPM
	# Requires: ZSH
    ################################
	expectUserInput 'Install recommanded plugins (zsh-autosuggestions, colored-man-pages, thefuck, mvn, zsh-syntax-highlighting, zsh-z)'
	if [ $userInput == 'y' ]; then
		# autosuggestions
		sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        # thefuck
    	sudo apt install -y python3-dev python3-pip python3-setuptools
		sudo pip3 install thefuck
    	# zsh-syntax-highlighting
		sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		# zsh-z
    	sudo git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
    fi

    ################################
    # RECOMMANDED-CONFIGS
    ################################
	expectUserInput 'Use recommanded configs'
	if [ $userInput == 'y' ]; then
		rm -rf ~/.zshrc
		ln -s $ABSOLUTE_CONFIG_PATH.zshrc ~/.zshrc
		ln -s $ABSOLUTE_CONFIG_PATH.p10k.zsh ~/.p10k.zsh
	fi
fi

################################
# KONSOLE
# Requires: UPM
################################
expectUserInput 'Install other terminal-program: Konsole (KDE)?'
if [ $userInput == 'y' ]; then
	sudo apt install -y konsole
fi

################################
# CIFS-UTILS
# Requires: UPM
################################
expectUserInput 'Install network-mount util: cifs-utils'
if [ $userInput == 'y' ]; then
	sudo apt install -y cifs-utils
fi

################################
# JAVA-8 (AS OPEN-JDK)
# Requires: UPM
################################
expectUserInput 'Install java open-jdk-8'
if [ $userInput == 'y' ]; then
	sudo apt install -y openjdk-8-jdk
fi

################################
# INSTALL COPY-PASTE
# Requires: UPM
################################
expectUserInput 'Install XCLIP (only useful under linux)'
if [ $userInput == 'y' ]; then
	sudo apt install -y xclip
fi

################################
# Backup-Dir (docker-databases)
################################
expectUserInput 'Install a backup-dir for dockerized databases (/backups/dbBackups/...)'
if [ $userInput == 'y' ]; then
	sudo mkdir /backups/
	sudo chmod -R 777 /backups/
	mkdir /backups/dbBackups/
	sudo chmod -R 777 /backups/dbBackups/
	mkdir /backups/dbBackups/postgresBackups/
fi

printf 'Finished, now recommanded: \n Check & update paths in the configs/vimrc and remove exentra specifics in scripts/dockeralias.sh'
