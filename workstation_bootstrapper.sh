#!/usr/bin/env zsh

#############################################################################
# INSTALLER SCRIPT FOR WORKSTATIONS
#############################################################################

function ssh_id_exists {
    if [ -f ~/.ssh/id_rsa.pub ]
    then
        echo '--> ssh ID exists!'

        echo '--> chmodding ssh ID just to be sure'
        # Maybe check if priveate key exists before doing this?
        chmod go-rwx ~/.ssh/id_rsa

        return 0
    else
        echo '--> ssh ID does not exist!'
        return 1
    fi
}

function generate_ssh_key {
    ssh-keygen -t rsa
}

function preconditions_satisfied {
    gcc_path=`which gcc`

    # This might not be the safest check, but for now it works:
    if [ which xload ]
    then
      echo '--> Xquartz required, opening download page'
      open http://xquartz.macosforge.org/landing/
      return 1
    fi
}

function install_ssh_key {
    if ssh_id_exists
    then
        echo '--> skipping ssh key generation'
    else
        echo '--> generating new ssh identity'
        generate_ssh_key
        echo "Copying public key to clipboard. Paste it into your Github account ..."
        [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
        open https://github.com/account/ssh
    fi
}

function install_homebrew {
    echo '--> installing homebrew and a few packages'
    sudo chown -R `whoami` /usr/local
    /usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
    brew update

    # Make sure older rubies can be compiled with gcc-4.2
    # on Mountain Lion:
    brew tap homebrew/dupes
    brew install apple-gcc42
}

function install_rvm {
  echo "--> installing RVM"
  curl -L https://get.rvm.io | bash -s stable
}

function abort {
    echo "--> aborting since preconditions are not satisfied. Make sure you
    have X-Code and it's CLI Tools installed, as well as X11!"
}

function setup_workstation {
    install_ssh_key
    install_homebrew
    install_rvm
    # install dotfiles, run puppet to install homebrew packages?
    # dropbox, 1password
    # mac-app store apps, other apps?
    # * set zsh as default shell
}

#############################################################################

if preconditions_satisfied
then
    setup_workstation
else
    abort
fi

#############################################################################
# TODO:
# * ssh key? Provide location?
# * puppet stuff
# * import dotfiles from config repository

# From thoughtbot:

  # homebrew path tuning
  # rvm path tuning

      ### DO THIS TROUGH PUPPET:
      #echo "Put Homebrew location earlier in PATH ..."
        #echo "
      ## recommended by brew doctor
      #export PATH='/usr/local/bin:$PATH'" >> ~/.zshrc

        #source ~/.zshrc
