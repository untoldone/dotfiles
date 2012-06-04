let mapleader = ","

nmap <silent> <leader>ev :e $MYVIMRC<CR>

" insert current directory on %%
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" mkdir to the current buffer location
cnoremap mk. !mkdir -p <c-r>=expand("%:h")<cr>/

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

"""""""""""""""""""
""" STATUS LINE 
"""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

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

