
command! Snake :call s:main()

nnoremap <F9><F9> :so %<CR>:Snake<CR>

let s:config = {
            \ 'width': 0,
            \ 'height': 0,
            \ 'border': 1,
            \ 'innerWidth': 0,
            \ 'innerHeight': 0,
            \ 'limitTop': 0,
            \ 'limitBottom': 0,
            \ 'limitLeft': 0,
            \ 'limitRight': 0,
            \ }

let s:seed = localtime()

let s:item = {
            \ 'wall': 'W',
            \ 'body': 'B',
            \ 'food': 'F',
            \ 'empty': ' ',
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
    call s:newFood()

    let l:loop = 1
    while l:loop == 1

        let l:input = nr2char(getchar(0))

        call s:updateDirection(l:input)
        call s:updateSnake()

        let l:isGameOver = s:checkGameOver(s:snake)

        if l:input == 'c' || l:isGameOver == 1
            break
        endif

        call s:moveSnake()

        sleep 100ms
        redraw

    endwhile

endfunction

"
function! s:checkGameOver(snake)
    let l:head = a:snake[0]
    for body in a:snake[1:]
        if body['x'] == l:head['x'] && body['y'] == l:head['y']
                    \ || body['x'] <= s:config['limitLeft']
                    \ || body['x'] >= s:config['limitRight']
                    \ || body['y'] <= s:config['limitTop']
                    \ || body['y'] >= s:config['limitBottom']
            return 1
        endif
    endfor
    return 0
endfunction

" game initialize
function! s:init()

    call s:createBuffer()
    call s:setLocalSetting()
    call s:setConfig()
    call s:setColor()
    call s:drawScreen(s:config, s:item)
    call s:setSnake(s:config['width']/2, s:config['height']/2)

endfunction

function! s:newFood()
    let l:randomX = s:rand(s:config['innerWidth'])
    let l:randomY = s:rand(s:config['innerHeight'])
    call s:drawChar(l:randomX, l:randomY, 'F')
endfunction

function! s:rand(div)
    let s:num = system('echo $RANDOM')[0:-2]
    return s:num % a:div
endfunction

"
function! s:updateDirection(input)
    if a:input == 'h'
        let s:direction = s:move['left']
    elseif a:input == 'j'
        let s:direction = s:move['down']
    elseif a:input == 'k'
        let s:direction = s:move['up']
    elseif a:input == 'l'
        let s:direction = s:move['right']
    endif
endfunction

"
function! s:moveSnake()
    let l:head = s:snake[0]
    let l:tail = s:snake[-1]
    call s:drawChar(l:head['x'], l:head['y'], s:item['body'])
    call s:drawChar(l:tail['x'], l:tail['y'], s:item['empty'])
endfunction

function! s:drawChar(x, y, char)
    execute "normal! " . a:y . 'gg0' . a:x . 'lr' . a:char . 'gg0'
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
    let s:snake = [ { 'x': a:x, 'y': a:y }, { 'x': a:x, 'y': a:y } ]
    let s:snake = s:snake + s:snake
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
    let l:width = winwidth(0)
    let l:height = winheight(0)
    let l:border = s:config['border']
    let s:config['width'] = l:width
    let s:config['height'] = l:height
    let s:config['innerWidth'] = l:width - (l:border * 2)
    let s:config['innerHeight'] = l:height - (l:border * 2)
    let s:config['limitTop'] = l:border + 1
    let s:config['limitBottom'] = l:height - l:border
    let s:config['limitLeft'] = l:border
    let s:config['limitRight'] = l:width - l:border - 1
endfunction

"
function! s:drawScreen(config, item)
    let l:width = a:config['width']
    let l:height = a:config['height']
    let l:wall = a:item['wall']

    let l:border = a:config['border']
    let l:innerHeight = a:config['innerHeight']
    let l:innerWidth = a:config['innerWidth']

    " draw full screen
    let lines = repeat([repeat(l:wall, l:width)], l:height)

    " draw game board
    for row in range(1,l:innerHeight)
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
    syntax match snakeHEAD 'H'
    syntax match snakeBody 'B'
    syntax match snakeFood 'F'
    highlight wall ctermfg=blue ctermbg=blue guifg=blue guibg=blue
    highlight snakeBody ctermfg=green ctermbg=green guifg=green guibg=green
    highlight snakeFood ctermfg=red ctermbg=red guifg=red guibg=red
endfunction
