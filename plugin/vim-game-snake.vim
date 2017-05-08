
command! Snake :call s:main()

nnoremap <F9><F9> :so %<CR>:Snake<CR>

let s:config = {
            \ 'width': 0,
            \ 'height': 0,
            \ }

let s:item = {
            \ 'wall': 'W'
            \ }

let s:snake = [ { 'x' : 1 , 'y' : 1 } ]
let s:direction = { 'x': 1, 'y': 0 }

let s:move = {
            \ 'left'  : { 'x' : -1 , 'y' : 0 },
            \ 'down'  : { 'x' : 0  , 'y' : 1 },
            \ 'up'    : { 'x' : 0  , 'y' : -1 },
            \ 'right' : { 'x' : 1  , 'y' : 0 },
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
    call s:setSnake(s:config['width']/2, s:config['height']/2)

    let l:loop = 1
    while l:loop == 1

        let l:input = nr2char(getchar(0))
        let l:loop = s:updateDirection(l:input)
        call s:updateSnake()
        call s:moveSnake()

        sleep 100ms
        redraw

    endwhile

endfunction

"
function! s:updateDirection(input)
    if a:input == 'c'
        return 0
    endif

    if a:input == 'h'
        let s:direction = s:move['left']
    elseif a:input == 'j'
        let s:direction = s:move['down']
    elseif a:input == 'k'
        let s:direction = s:move['up']
    elseif a:input == 'l'
        let s:direction = s:move['right']
    endif

    return 1
endfunction

"
function! s:moveSnake()
    let l:head = s:snake[0]
    let l:tail = s:snake[-1]
    execute "normal! " . l:head['y'] . 'gg0' . l:head['x'] . 'lrB'
    execute "normal! " . l:tail['y'] . 'gg0' . l:tail['x'] . 'lr '
endfunction

"
function! s:updateSnake()
    let l:dx = s:direction['x']
    let l:dy = s:direction['y']
    let l:head = s:snake[0]
    let l:newHead = { 'x': l:head['x'] + l:dx, 'y': l:head['y'] + l:dy }
    let s:snake = [ l:newHead ] + s:snake[0:-2]
endfunction

"
function! s:setSnake(x, y)
    let s:snake = [ { 'x': a:x, 'y': a:y }]
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
