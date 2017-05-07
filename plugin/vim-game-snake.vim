
let s:config = {
            \ 'width': 0,
            \ 'height': 0,
            \ }

function! s:main()

    call s:init()

endfunction

" game initialize
function! s:init()

    call s:createBuffer()
    call s:setLocalSetting()
    call s:setConfig()

    "
    function! s:createBuffer()
        silent edit `='VIM-GAME-SNAKE'`
    endfunction

    "
    function! s:setLocalSetting()
        setlocal bufhidden=wipe
        setlocal buftype=nofile
        setlocal buftype=nowrite
        setlocal nocursorcolumn
        setlocal nocursorline
        setlocal nolist
        setlocal nonumber
        setlocal noswapfile
        setlocal nowrap
    endfunction

    "
    function! s:setConfig()
        let s:config['width'] = winwidth(0)
        let s:config['height'] = winheight(0)
    endfunction

endfunction

command! Snake :call s:main()

nnoremap <F9><F9> :so %<CR>:Snake<CR>
