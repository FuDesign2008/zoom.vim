
if &cp || exists("g:loaded_zoom")
    finish
endif

let g:loaded_zoom = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:getFontSize(str)
    return substitute(a:str, '^.*:h\([^:]*\).*$', '\1', '')
endfunction

function s:setFontSize(size)
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


function! s:RandomFont
    if exists("g:zoom_favorite_fonts")
        let remainder = localtime() % len(g:zoom_favorite_fonts)
        let value = get(g:zoom_favorite_fonts, remainder, '')
        if value == ''
            return
        endif
        let s:default_font_size = s:getFontSize(value)
        let &guifont = value
    endif
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
    nnoremap = :ZoomIn<CR>
    nnoremap - :ZoomOut<CR>
    nnoremap 0 :ZoomReset<CR>
endif


let &cpo = s:save_cpo
finish

