"compiler to call jshint on javascript file

if exists('current_compiler')
  finish
endif
let current_compiler = 'jshint'

if exists(":CompilerSet") != 2
	command -nargs=* CompilerSet setlocal <args>
endif

"allow overriding lint on save (default is true)
if !exists('g:jshint_onwrite')
    let g:jshint_onwrite = 1
endif

if exists(':JSHint') != 2
    command JSHint :call JSHint(0)
endif

"jshint:  npm install -g jshint
if executable('jshint')
  
  execute 'setlocal efm=%f:\ line\ %l\\,\ col\ %c\\,\ %m'

  execute 'setlocal makeprg=jshint\ %' 

endif

if g:jshint_onwrite
    augroup javascript
        au!
        au BufWritePost *.js call JSHint(1)
    augroup end
endif

function! JSHint(saved)

    if !a:saved && &modified
        " Save before running
        write
    endif	

	"shellpipe
    if has('win32') || has('win16') || has('win95') || has('win64')
        setlocal sp=>%s
    else
        setlocal sp=>%s\ 2>&1
    endif

    if g:jshint_goto_error
	silent lmake
    else
	silent lmake!
    endif
	
    "open local window with errors
    :lwindow
	
endfunction
