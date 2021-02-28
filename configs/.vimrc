" Enable syntax highlighting
syntax on

" Enable line numbers
set number

"=====TAB CONFIGURATION=====

" Insert space characters whenever tab is pressed
set expandtab

" Make tabs as wide as four spaces
set tabstop=4

" Number of space characters used with a tab
set shiftwidth=4

" Only fills up to a full tab instead of making a tab (4 Chars)
set softtabstop=4

"=====TAB CONFIGURATION=====

"=====ENCODING====="
scriptencoding utf-8
set encoding=utf-8

" Write configuration
set backspace=indent,eol,start

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Highlight cursorline!
set cursorline

" Always show current position
set ruler

"// PLUGINS \\

set nocompatible              " be iMproved, required
filetype plugin indent on     " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

"\\ PLUGINS //
