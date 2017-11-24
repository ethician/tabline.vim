" File:        tabline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/>
" Description: Configure tabs within Terminal Vim.
" Last Change: 2012-10-21
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" Based On:    http://www.offensivethinking.org/data/dotfiles/vimrc

" Bail quickly if the plugin was loaded, disabled or compatible is set
if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
  finish
endif
let g:loaded_tabline_vim = 1

function! CreateTabline(first_tabpagenr)
  let e = '['
  let s = '['
  let last_tabpagenr = tabpagenr('$') - 1
  if a:first_tabpagenr > 0
    let s = '<'
    let e = '<'
  endif
  for i in range(a:first_tabpagenr, last_tabpagenr)
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")
    let p = ''

    let p .= '%' . tab . 'T'
    let p .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    "let p .= ' ' . tab .':'
    let p .= ' ' . tab 
    let e .= ' ' . tab 
    if bufmodified
      let p .= '+'
      let e .= '+'
    else
      let p .= ' '
      let e .= ' '
    endif
    "let p .= (bufname != '' ? fnamemodify(bufname, ':t') : '[No Name]')
    if bufname == ''
      let p .= '[NoName]'
      let e .= '[NoName]'
    else
      if getbufvar(bufnr, "&buftype" ) == 'help'
        let p .= '[H]' . fnamemodify(bufname, ':t:s/.txt$//' )
        let e .= '[H]' . fnamemodify(bufname, ':t:s/.txt$//' )
      elseif getbufvar(bufnr, "&buftype" ) == 'quickfix'
        let p .= '[Q]'
        let e .= '[Q]'
      else
        let p .= pathshorten(bufname)
        let e .= pathshorten(bufname)
      endif
    endif
    let p .= ' '
    let e .= ' 00'
    if strlen(e) >= &columns
      if i > tabpagenr()
        let s .= '%#TabLineFill#%=' . (tabpagenr('$') - i) . '>'
        return s
      endif
      return CreateTabline(a:first_tabpagenr + 1)
    endif
    let s .= p
  endfor
  let s .= '%#TabLineFill#%=]'
  "if (exists("g:tablineclosebutton"))
    "let s .= '%=%999XX'
  "endif
  return s
endfunction

set tabline=%!CreateTabline(0)
