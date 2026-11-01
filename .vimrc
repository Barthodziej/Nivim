set expandtab
set tabstop=4
set shiftwidth=4
set autoread

syntax on

"Increasing line limit in registers when changing files
set viminfo='100,<5000,s10,h

"Local config files"
set exrc
set secure

"XML autocomplete closing tag: </ + ctrl-x + ctrl-o
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd BufRead,BufNewFile *.axaml set filetype=xml

"Prolog highlghting for .pro
"let extension = expand('%:e')
"if (extension == 'pro')
"    setlocal filetype=pro
"endif
autocmd BufRead,BufNewFile *.pro set filetype=prolog
autocmd FileType prolog setlocal syntax=prolog

call plug#begin()

Plug 'kaarmu/typst.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'junegunn/vim-easy-align'
Plug 'wolandark/vim-loremipsum'
Plug 'neovimhaskell/haskell-vim'

call plug#end()

set signcolumn=yes

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd', '--background-index']},
            \ 'whitelist': ['cpp', 'hpp'],
            \ })
        autocmd FileType cpp,hpp setlocal omnifunc=lsp#complete
    augroup end
endif

if executable('jdtls')
    augroup lsp_jdtls
	autocmd!
	autocmd User lsp_setup call lsp#register_server({
	    \ 'name': 'jdtls',
	    \ 'cmd' : {server_info->['jdtls']},
	    \ 'root_uri':{server_info->lsp#utils#path_to_uri(
	    \    lsp#utils#find_nearest_parent_file_directory(
	    \        lsp#utils#get_buffer_path(),
	    \        ['pom.xml', '.git']
	    \    )
	    \ )},
	    \ 'whitelist': ['java'],
	    \ })
	autocmd FileType java setlocal omnifunc=lsp#complete
    augroup end
endif

if executable('omnisharp')
    function! s:get_project_root() abort
        let l:root = lsp#utils#find_nearest_parent_file_directory(
        \   lsp#utils#get_buffer_path(),
        \   [ '.git' ]
        \ )
        return empty(l:root) ? getcwd() : l:root 
    endfunction
    augroup lsp_omnisharp
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'omnisharp',
            \ 'cmd': {server_info->[
            \     'omnisharp',
            \     '--languageserver',
            \     '--hostPID', string(getpid())
            \ ]},
            \ 'root_uri': {server_info->lsp#utils#path_to_uri(
            \     s:get_project_root()
            \ )},
            \ 'allowlist': ['cs'],
            \ })
        autocmd FileType cs setlocal omnifunc=lsp#complete
    augroup end
endif

nnoremap <silent> <leader>a :LspCodeAction --ui=float<CR>

highlight SignColumn ctermbg=None
highlight LspWarningHighlight ctermfg=Yellow ctermbg=None
highlight LspWarningText ctermfg=Yellow ctermbg=None cterm=italic
highlight LspErrorHighlight ctermfg=Red ctermbg=None
highlight LspErrorText ctermfg=Red ctermbg=None cterm=italic
highlight PMenu ctermfg=White ctermbg=None cterm=italic
highlight link markdownCode Identifier

highlight TabLine ctermbg=None ctermfg=White cterm=None
highlight TabLineSel ctermbg=None ctermfg=None cterm=bold
highlight TabLineFill cterm=None

"vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
