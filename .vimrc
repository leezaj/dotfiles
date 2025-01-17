" Keybind for paste mode
set pastetoggle=<F2>

" Keybind for to toggle spellchecking
:map <F3> :setlocal spell! spelllang=en_us<CR>

" Keybind that clears search highlights when pressing Backslash
nnoremap \ :noh<CR>

" changes the cursor based on normal/insert mode
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" always show the status line
set laststatus=2
" status line with buffer number, file name, row and column numbers as well as percentage through file
set statusline+=[%n]%<%F\ %m%r%h%w%=%-14.(%l/%L,%c%V%)\ %P\ 
set statusline+=%{wordcount().words}\ words

" Some basics:
nnoremap c "_c
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber

" Enable autocompletion:
set wildmode=longest,list,full

" Splits open at the bottom and right
set splitbelow splitright
" Easier split navigation
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

" Change color of highlights
hi Visual cterm=bold ctermbg=8
hi Search cterm=reverse ctermbg=8
hi SpellBad cterm=reverse,bold ctermbg=8 ctermfg=9
hi DiffAdd cterm=reverse ctermbg=8 ctermfg=10
hi DiffDelete cterm=reverse ctermbg=8 ctermfg=9
hi DiffChange cterm=reverse ctermbg=8 ctermfg=11
hi DiffText cterm=reverse ctermbg=8 ctermfg=15

" Navigate wrapped lines smoothly
"nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
"nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
