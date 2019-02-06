#!/bin/bash

set -e

if [ ! -d ~/build ]; then
    mkdir -p ~/build
fi

cd ~/build/

if [ ! -d ~/build/vim ]; then
    git clone https://github.com/vim/vim.git
fi

cd vim

sudo git pull
sudo make distclean

sudo apt install libxmu-dev libgnomeui-dev libxpm-dev tcl-dev libperl-dev lua5.2 liblua5.2-dev luajit -y

py2conf=`python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LIBPL')"`
py3conf=`python3 -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LIBPL'))"`

sudo LDFLAGS="-Wl,-rpath=${HOME}/.anyenv/envs/pyenv/versions/2.7.15/lib:${HOME}/.anyenv/envs/pyenv/versions/3.6.7/lib:${HOME}/.anyenv/envs/rbenv/versions/2.5.1/lib" ./configure \
    --with-features=huge \
    --enable-fail-if-missing \
    --enable-terminal \
    --enable-luainterp=dynamic \
    --enable-perlinterp=dynamic \
        --with-python-config-dir=$py2conf \
    --enable-pythoninterp=dynamic \
        --with-python3-config-dir=$py3conf \
    --enable-python3interp=dynamic \
        --with-ruby-command=$HOME/.anyenv/envs/rbenv/shims/ruby \
    --enable-rubyinterp=dynamic \
    --enable-tclinterp=dynamic \
    --enable-cscope \
    --enable-multibyte \
    --enable-xim \
    --enable-gui=no \
    --enable-fontset

sudo make
sudo make install

vim --version
