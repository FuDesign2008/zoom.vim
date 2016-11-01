
if &cp || exists('g:loaded_zoom')
    finish
endif

let g:loaded_zoom = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:getFontSize(str)
    return substitute(a:str, '^.*:h\([^:]*\).*$', '\1', '')
endfunction

function! s:setFontSize(size)
    let value = substitute(&guifont, ':h\([^:]*\)', ':h' . a:size, '')
    let &guifont = value
endfunction


" keep default value
let s:default_font_size = s:getFontSize(&guifont)

" guifont size + 1
function! s:ZoomIn()
    let size = s:getFontSize(&guifont)
    let size += 1
    call s:setFontSize(size)
endfunction

" guifont size - 1
function! s:ZoomOut()
    let size = s:getFontSize(&guifont)
    let size -= 1
    call s:setFontSize(size)
endfunction

" reset guifont size
function! s:ZoomReset()
    call s:setFontSize(s:default_font_size)
endfunction


"==============================================================================
" RandomNumber is taken from
" https://github.com/dahu/vim-rng/blob/master/plugin/rng.vim
"==============================================================================
let s:m_w = 1 + getpid()
let s:m_z = localtime()

" not sure of the wisdom of generating a full 32-bit RN here
" and then using abs() on the sucker. Feedback welcome.
function! s:RandomNumber(...)
  if a:0 == 0
    let s:m_z = (36969 * and(s:m_z, 0xffff)) + (s:m_z / 65536)
    let s:m_w = (18000 * and(s:m_w, 0xffff)) + (s:m_w / 65536)
    return (s:m_z * 65536) + s:m_w      " 32-bit result
  elseif a:0 == 1 " We return a number in [0, a:1] or [a:1, 0]
    return a:1 < 0 ? s:RandomNumber(a:1,0) : s:RandomNumber(0,a:1)
  else " if a:2 >= 2
    return abs(s:RandomNumber()) % (abs(a:2 - a:1) + 1) + a:1
  endif
endfunction
" end RNG }}}
"============


"@param {Integer} max
"@return {Integer} return a integer between [0, max - 1]
function! s:RandomInt(max)
    return s:RandomNumber(a:max)
endfunction

"@param {List} theList should be unique
"@return {List}
function! s:RandomOrder(theList)

    let uniqueArr = uniq(copy(a:theList))

    let length = len(uniqueArr)
    let newList = []
    let counter = 0

    while counter < length
        let index = s:RandomInt(length)
        let item = get(uniqueArr, index)

        while index(newList, item) != -1
            let index = s:RandomInt(length)
            let item = get(uniqueArr, index)
        endwhile

        call add(newList, item)
        let counter = counter + 1
    endwhile

    return newList
endfunction

let s:favoriteFontsWithRandom = []
function! s:RandomFont()
    if exists('g:zoom_favorite_fonts') && empty(s:favoriteFontsWithRandom)
        let s:favoriteFontsWithRandom = s:RandomOrder(g:zoom_favorite_fonts)
    endif

    if empty(s:favoriteFontsWithRandom)
        return
    endif

    let item = remove(s:favoriteFontsWithRandom, 0)
    let s:default_font_size = s:getFontSize(item)
    let &guifont = item
endfunction


" command
command! -narg=0 ZoomIn         :call s:ZoomIn()
command! -narg=0 ZoomOut        :call s:ZoomOut()
command! -narg=0 ZoomReset      :call s:ZoomReset()
command! -narg=0 RandomFont     :call s:RandomFont()

if exists('g:zoom_random_font') && g:zoom_random_font
    call s:RandomFont()
endif

if exists('g:zoom_key_map') && g:zoom_key_map
    nnoremap <Leader>= :ZoomIn<CR>
    nnoremap <leader>- :ZoomOut<CR>
    nnoremap <leader>0 :ZoomReset<CR>
endif


let &cpo = s:save_cpo
finish

