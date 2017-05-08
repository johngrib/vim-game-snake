
command! Snake :call s:main()

nnoremap <F9><F9> :so %<CR>:Snake<CR>

let s:config = {
            \ 'width': 0,
            \ 'height': 0,
            \ }

let s:item = {
            \ 'wall': 'W'
            \ }

function! s:main()

    call s:init()

endfunction

" game initialize
function! s:init()

    call s:createBuffer()
    call s:setLocalSetting()
    call s:setConfig()
    call s:setColor()
    call s:drawScreen(s:config, s:item)

endfunction

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
    setlocal nonumber
    setlocal norelativenumber
endfunction

"
function! s:setConfig()
    echomsg winwidth(0)
    let s:config['width'] = winwidth(0)
    let s:config['height'] = winheight(0)
endfunction

"
function! s:drawScreen(config, item)
    let l:width = a:config['width']
    let l:height = a:config['height']
    let l:wall = a:item['wall']

    let l:border = 1
    let l:innerHeight = l:height - (l:border * 2)
    let l:innerWidth = l:width - (l:border * 2)

    " draw full screen
    let lines = repeat([repeat(l:wall, l:width)], l:height)

    " draw game board
    for row in range(1,l:height-2)
        let lines[row] = repeat(l:wall, l:border)
                    \ .repeat(' ', l:innerWidth)
                    \ .repeat(l:wall, l:border)
    endfor

    " draw on buffer
    call setline(1, lines)
    redraw
endfunction

"
function! s:setColor()
    syntax match wall 'W'
    highlight wall ctermfg=blue ctermbg=blue guifg=blue guibg=blue
endfunction
