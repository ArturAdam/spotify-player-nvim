scriptencoding utf-8

if exists('g:loaded_spotify') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 SpotifyPlayer lua require('spotify-player).setup()

let g:loaded_spotify = 1

let &cpo = s:save_cpo
unlet s:save_cpo
