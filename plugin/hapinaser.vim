" Vim global plugin for correcting typing mistakes
" Last Change:	2016 December 24
" Maintainer:   Noriaki Oshita <noriaki_oshita@whispon.com>

if exists('g:loaded_sentiment_vim')
  finish
endif

let g:loaded_sentiment_vim = 1
let s:save_cpo = &cpo
set cpo&vim

"Get an access token. Specify the location of the access_token file.
"Get the information. https://cloud.google.com/natural-language/docs/getting-started
let s:configfile = join(readfile('/Users/noriakioshita/.config/nvim/plugin/.sentiment.vim'))

function! s:load_settings()
  let s:settings = s:configfile
endfunction

function! s:initialize()
  call s:load_settings()
  "echo s:settings
endfunction

function! s:Sentiment()
  call s:initialize()
  let json = join(readfile("./message.json"))
  let url = 'https://language.googleapis.com/v1/documents:analyzeSentiment'
  let res = webapi#http#post(url, json, {'Authorization': 'Bearer ' . s:settings,'Content-Type': 'application/json'})
  echo res
endfunction

command! Hapinaser :call s:Sentiment()

let &cpo = s:save_cpo
unlet s:save_cpo
