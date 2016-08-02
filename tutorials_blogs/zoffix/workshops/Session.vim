let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +0 ~/work/rakudo/tutorials_blogs/zoffix/workshops/README
badd +20 ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/README
badd +0 ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/t/key
badd +0 ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/t/author/01-meta.t
badd +0 ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/t/online/01-weather-for.t
args ~/work/rakudo/tutorials_blogs/zoffix/workshops/README
edit ~/work/rakudo/tutorials_blogs/zoffix/workshops/README
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe '1resize ' . ((&lines * 0 + 25) / 50)
exe '2resize ' . ((&lines * 46 + 25) / 50)
exe '3resize ' . ((&lines * 0 + 25) / 50)
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
edit ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/README
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 33 - ((31 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
33
normal! 055|
wincmd w
argglobal
edit ~/work/rakudo/tutorials_blogs/zoffix/workshops/weatherapp/t/online/01-weather-for.t
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 11 - ((10 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
11
normal! 040|
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 0 + 25) / 50)
exe '2resize ' . ((&lines * 46 + 25) / 50)
exe '3resize ' . ((&lines * 0 + 25) / 50)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:this_session = v:this_session
let g:this_obsession = v:this_session
let g:this_obsession_status = 2
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
