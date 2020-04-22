
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

" @param {Integer} [step = 1]
function! s:ZoomIn(step)
    let stepInt = a:step + 0
    if stepInt < 1
        let stepInt = 1
    endif
    let size = s:getFontSize(&guifont)
    let size += stepInt
    call s:setFontSize(size)
endfunction

" @param {Integer} [step = 1]
function! s:ZoomOut(step)
    let stepInt = a:step + 0
    if stepInt < 1
        let stepInt = 1
    endif
    let size = s:getFontSize(&guifont)
    let size -= stepInt
    call s:setFontSize(size)
endfunction

" reset guifont size
function! s:ZoomReset()
    call s:setFontSize(s:default_font_size)
endfunction


function! s:ZoomInStrongly()
    call s:ZoomIn(4)
endfunction

function! s:ZoomOutStrongly()
    call s:ZoomOut(4)
endfunction


" command
command! -narg=? ZoomIn         :call s:ZoomIn(<args>)
command! -narg=? ZoomOut        :call s:ZoomOut(<args>)
command! -narg=0 ZoomReset      :call s:ZoomReset()
command! -narg=0 ZoomInStrongly     :call s:ZoomInStrongly()
command! -narg=0 ZoomOutStrongly    :call s:ZoomOutStrongly()

if exists('g:zoom_key_map') && g:zoom_key_map
    nnoremap <Leader>= :ZoomIn<CR>
    nnoremap <leader>- :ZoomOut<CR>
    nnoremap <leader>0 :ZoomReset<CR>
endif


let &cpo = s:save_cpo
finish

