" Extra settings
if filereadable("/import/stargate/grid/scripts/group_vimrc")
  source /import/stargate/grid/scripts/group_vimrc
endif

if filereadable("/import/stargate/grid/scripts/group_vimrc")
  colorscheme iceberg
else
  colorscheme desert
endif

" Notes:
" c-6 to switch to the alternate buffer
" 'ma' sets a bookmark on current line called 'a'
" `a goes to bookmark 'a'

" Prevent Vi compatibility from interrtupting
set nocompatible

" Top-level settings

syntax enable
filetype plugin on
filetype indent on
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos

" Repace inner word with yanked buffer contents
map <C-p> ciw<C-r>0<ESC>

" Set folding
set foldmethod=indent
set nofoldenable
"autocmd Syntax c,cpp,vim,xml,html,xhtml setlocal foldmethod=syntax
"autocmd Syntax c,cpp,vim,xml,html,xhtml normal! zR

" Basic operation
set wildmenu
set wildignore=*.o,*~,*.ko,*.cmd,*.pyc
set ruler
set hid
set lazyredraw
set history=700
set scrolloff=3             " Minimum number of lines above or below cursor on screen
set cursorline              " Highlight line cursor is on
set cc=80                   " Set column line at pos 80
set splitbelow
set splitright
set tabpagemax=99
nnoremap <s-c-q> :q!<cr>    " force close current window

" Automatically set hybrid line numbers on active buffer
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Indents
set autoindent
set smartindent
set wrap
set shiftwidth=2
set tabstop=2

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic
set showmatch
" Remove highlighted word from searching with '\ '
" nnoremap <Leader><space> :let @/=""<cr>

" Quick shortcuts
" Expand `%.` to open folder of current file
cabbr <expr> %. expand('%:p:h')
" Expand `#.` to open folder of alternate file
cabbr <expr> #. expand('#:p:h')
" Paste mode with F3 - prevent formatting
set pastetoggle=<F3>
" Auto insert closing curly brace
inoremap {<cr> {<cr>}<Esc>ko
" Switch to alternate buffer
nnoremap <s-b><s-b> :e #<cr>
" Modify home and end keys to be more useful and predictable
nnoremap <home> ^
vnoremap <home> ^
inoremap <home> <c-o>^
nnoremap <end> $
vnoremap <end> $
inoremap <end> <c-o>$
command! Qt tabclose
" Bind shift tab in insert mode to dedent
inoremap <S-Tab> <C-d>
" Rebind opposite of <c-o>
nnoremap <c-p> <c-i>
" sv to source vimrc
nnoremap <leader>sv :source ~/.vimrc<cr>
" ev to edit vimrc
nnoremap <leader>ev :vsplit ~/.vimrc<cr>
" Dont exit visual mode when indenting
vnoremap > >gv
vnoremap < <gv
" Ctrl-O to insert line below cursor, Ctrl-Shift-O to insert line above
" nnoremap <C-S-o> O<ESC><Down>
" nnoremap <C-S-o> o<ESC><Up>
" Open split containing git blame info with \b
:nnoremap <leader>b <C-w>n<C-w>L:0 r !git blame #<cr>:%s/).*/)/<cr>:let @/=""<cr>

" Fix backspace
set backspace=eol,start,indent
" Allow wraping in normal and visual mode
set whichwrap+=<,>,h,l

" Status window status bar
set laststatus=2
set noshowmode " hide "--- MODE ---" b/c status bar handles that

" Terminal controls
" Open terminal above current window
"nnoremap <leader>y :term ++close<cr>
"tnoremap <leader>y <c-w>:term ++close<cr>
" Allow window movement with \[wasd]
" Exit terminal mode (enter normal mode)
"tnoremap <esc> <c-w>N

set statusline=%!MyStatusLine()
function! MyStatusLine()
    let s = ''
    let s .= '%#PmenuSel#'
    if mode() == "\<C-V>"
        let s .= ' B '
    else
        let s .= ' ' . mode() . ' '
    endif
    let s .= '%*'
    let s .= ' %f%m'
    let s .= '%='
    if has("gui_running")
      let s .= ' #%{fnamemodify(bufname("#"), ":t")}'
      " let s .= ' @%{getcwd()}'
    endif
    let s .= ' %y'
    let s .= ' %P'
    let s .= ' %l/%L:%c'
    let s .= ' '
    return s
endfunction

set showtabline=2
set tabline=%!MyTabLine()
" Custom command to name the current tab
command! -nargs=? NameTab :call settabvar(tabpagenr(), "title", <q-args>) | redraw!
function! MyTabLine()
    let s = ''
    for t in range(tabpagenr('$'))
        let s .= '%#PmenuSel#'
        " set tab number
        let s .= ' '
        let s .= t + 1 . ' '
       " Check if selected, set highlight
        if t+1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        if gettabvar(t+1,"title") != ""
            " If a custom tab name is set, use that
            let s .= ' '
            let s .= gettabvar(t+1,"title") . ' '
        else
            " otherwise, list buffers + status
            let n = ' ' " temp string for buffer names while checking buftype
            " loop through buffers in tab
            for b in tabpagebuflist(t+1)
                if getbufvar( b, "&buftype" ) == 'help' " Help tabs get ignored
                    let n .= '' " '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                elseif getbufvar( b, "&buftype" ) == 'quickfix' " Quickfix gets [Q] only
                    let n .= '[Q]'
                else " All other tabs get the file name only
                    let fname = fnamemodify(bufname(b), ":t")
                    if stridx(n, fname) == -1
                        let n .= fname
                        " check and add &modified
                        if getbufvar(b, "&modified")
                            let n .= '[+]'
                        endif
                        let n .= ' '
                    endif
                endif
            endfor
            " add buffer names TODO change this?
            if n == ' '
                let s .= ' [New] '
            else
                let s .= n
            endif
        endif
    endfor
    let s .= '%*' " Return to normal hilighting
    " after tabs, fill the space and reset tab page nr
    let s .= '%='
    let s .= '%#PmenuSel#' . ' # ' . '%#TabLine# '
    let s .= '%{fnamemodify(bufname("#"), ":t")} '
    let s .= '%#PmenuSel#' . ' @ ' . '%#TabLine# '
    let s .= '%{getcwd()}%< '
    return s
endfunction

" Disable backups (use git)
set nobackup
set nowb
set noswapfile

" Window management (Lots here but thats what makes VIM less of a pain to use)
" Ctrl-e to free Ctrl-w for mapping
nnoremap <c-e> <c-w>
" Tab to switch windows, | to split horizontally, - to split vertically
nnoremap <Tab> <c-w>w
nnoremap <Bar> <c-w>v<c-w><Right>
nnoremap -     <c-w>s<c-w><Down>
" Ctrl-PageUp to increase horizontal size, Ctrl-PageDown to decrease
" nnoremap <c-PageUp>   <C-w>>
" nnoremap <c-PageDown> <C-w><
" " PageUp to increase vertical size, PageDown to decrease
" nnoremap <PageUp>   <C-w>+
" nnoremap <PageDown> <C-w>-
" Ctrl-T to move window to a new tab
nnoremap <c-t> <c-w>T
" \[WASD] to move windows and \r to rotate
noremap <leader>w <c-w>K
noremap <leader>s <c-w>J
noremap <leader>a <c-w>H
noremap <leader>d <c-w>L
noremap <leader>r <c-w>r

" Tab management
nnoremap <S-Tab> :call ShiftTab()<cr>
" Use \t to create a tab
nnoremap <Leader>t :tabnew<cr>
" Use \q \e to move a tab
nnoremap <leader>q :tabmove -1<cr>
nnoremap <leader>e :tabmove +1<cr>
" If only 1 tab, rotate windows in reverse. Otherwise, next tab
function! ShiftTab()
    " Check number of open tabs
    if tabpagenr('$') == 1
        execute "silent! normal! :wincmd W\<cr>"
    else
        execute "normal! :tabnext\<cr>"
    endif
endfunction

" Screen management
" Ctrl-up to move screen up, Ctrl-down to move screen down
noremap <c-Down> <c-e>
noremap <c-Up> <c-y>
inoremap <c-Down> <c-c><c-e>
inoremap <c-Up> <c-x><c-y>
" [} to go to end of current block
" ]{ to go to start of current block
nnoremap ]{ 999[{
nnoremap [} 999]}

" Line management
nnoremap > :move .+1<cr>
nnoremap < :move .-2<cr>

" Alternate file editing
command! Ea :vs #

" Session Saving
" Save localoptions b/c my _vimrc needs to be sourced on uframe
set ssop=blank,buffers,curdir,help,tabpages,winsize,localoptions,folds
autocmd! VimLeave * mksession! ~/.lastsession.vim
" Use Set and Get to save and load session in current directory.
command! Get :source .session.vim
command! Set mksession! .session.vim
" Variants for the last saved session
command! Getl :source ~/.lastsession.vim
command! Setl mksession! ~/.lastsession.vim

" Reload file if externally modified
set autoread
au FocusGained,BufEnter * checktime

" Disable bell
set noerrorbells
set novisualbell
set t_vb=
set tm=500

command! Delreg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

" Load tags for current project. \] to open a preview of symbol under cursor
set tags=./tags;,tags;
nnoremap <leader>] <c-w>}
"<c-w><Up> can appear anywhere so dont press something random

" Run python in Vim
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
