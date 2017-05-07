
let s:config = {
            \ }


function! s:main()

    silent edit `='VIM-GAME-SNAKE'`

endfunction


command! Snake :call s:main()

nnoremap <F9><F9> :so %<CR>:Snake<CR>
