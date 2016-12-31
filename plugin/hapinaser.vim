" Vim global plugin for correcting typing mistakes
" Last Change:	2015 December 24
" Maintainer:   Noriaki Oshita <noriaki_oshita@whispon.com>

if exists('g:loaded_sentiment_vim')
  finish
endif

let g:loaded_sentiment_vim = 0
let s:save_cpo = &cpo
set cpo&vim

"Get an accdess token. Specify the location of the access_token file.
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
  "let json = join(readfile("./message.json"))
  let url = 'https://language.googleapis.com/v1/documents:analyzeSentiment'
  let res = webapi#http#post(url, '{"document": {"type": "PLAIN_TEXT","language": "JA","content":"' . s:message . '"},"encodingType": "UTF8"}', {'Authorization': 'Bearer ' . s:settings,'Content-Type': 'application/json'})
  let outputfile = '/Users/noriakioshita/.config/nvim/plugin/output.json'
  execute "redir! > " . outputfile
  silent! echon res
  redir END
  silent! e /Users/noriakioshita/.config/nvim/plugin/output.json
  let match_line = search("documentSentiment",'b',line("w20"))

  let s:gyo1 = getline(match_line)
  let s:gyo2 = getline(match_line + 1)
  let s:gyo3 = getline(match_line + 2)
  silent! bp
  if match_line != 0
    echo s:gyo1.s:gyo2.s:gyo3 
  endif
endfunction

function! GetLineText()
  let s:message = getline('.')
  call s:Sentiment()
  "Initialize variables to analyze sentences continuously
  unlet s:gyo1
  unlet s:gyo2
  unlet s:gyo3
endfunction

command! Hapinaser :call s:Sentiment()
command! Getline :call g:GetLineText()

nnoremap <C-g> :Getline<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
