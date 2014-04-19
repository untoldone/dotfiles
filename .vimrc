""""""""""""""""""
""" BASIC CONFIG
"""""""""""""""""
set hidden
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" Put the status bar at the bottom
set laststatus=2
" Show the matching bracket for the last ')'
set showmatch
" use incremental search (search as you type)
set incsearch
" highlight search
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=2
" if you try to reopen an already open file -- use the already open buffer
set switchbuf=useopen
set number
" width of the line number column
set numberwidth=5
" Show the current tab number
set showtabline=2
set winwidth=79
set shell=bash
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" store temporary files in a central spot (and out of repos when possible)
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" display incomplete commands
set showcmd
" endable highlighting for syntax
syntax on


let mapleader = ","

nmap <silent> <leader>ev :e $MYVIMRC<CR>

" insert current directory on %%
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" mkdir to the current buffer location
cnoremap mk. execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) \| redraw!

"""""""""""""""""
""" COLOR
"""""""""""""""""
:set t_Co=256 " 256 colors
:set background=dark
:color grb256

"""""""""""""""""""
""" AUTO COMMANDS
"""""""""""""""""""
augroup vimrcEx
  " clear all autocmds in the group
  autocmd!
  " jump to last cursor position unless its invalid or an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END
"""""""""""""""""""""
""" WHY NO HJKL!!!
"""""""""""""""""""""
map <Left> :echo "no!, use h"<cr>
map <Right> :echo "no!, use l"<cr>
map <Up> :echo "no!, use k"<cr>
map <Down> :echo "no!, use j"<cr>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"""""""""""""""""""
""" STATUS LINE 
"""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""
""" MISC KEY MAPS
""""""""""""""""""""
imap <c-l> <space>=><space>
map <Leader>[ :setl noai nocin nosi inde=<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

"""""""""""""""""""""""
""" TAB COMPLETION 
"""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
"""""""""""""""""""""""""""
""" RENAME CURRENT FILE
"""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

"""""""""""""""""""""""""""
""" REMOVE CURRENT FILE
"""""""""""""""""""""""""""
command! Rm call delete(expand('%')) | bdelete!

"""""""""""""""""""""""""""""""""""""""""""""
""" SWTICH BETWEEN TEST AND PRODUCTION CODE
"""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  "let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    let new_file = substitute(new_file, '^app/', '', '')
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    let new_file = 'app/' . new_file
    if !filereadable(new_file) && filereadable('lib/' . new_file)
      let new_file = 'lib/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

"""""""""""""""""""
""" RUNNING TESTS
"""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    exec ":!rspec --color --drb " . a:filename
endfunction

""""""""""""""""""""
""" WINDOW HELPERS
""""""""""""""""""""
map <leader>gg :topleft 100 :split Gemfile<cr>
set winheight=10
set helpheight=10
set winminheight=5
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
