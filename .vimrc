set expandtab
set tabstop=4
set shiftwidth=4
set autoread

syntax on

"Increasing line limit in registers when changing files
set viminfo='100,<5000,s10,h

"XML autocomplete closing tag: </ + ctrl-x + ctrl-o
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd BufRead,BufNewFile *.axaml set filetype=xml

call plug#begin()

Plug 'kaarmu/typst.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'neovimhaskell/haskell-vim'
Plug 'wolandark/vim-loremipsum'

call plug#end()

set signcolumn=yes

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd', '--background-index']},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
            \ })
        autocmd FileType c,cpp setlocal omnifunc=lsp#complete
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

nnoremap <silent> <leader>a :LspCodeAction --ui=float<CR>

highlight SignColumn ctermbg=None
highlight LspWarningHighlight ctermfg=Yellow ctermbg=None
highlight LspWarningText ctermfg=Yellow ctermbg=None cterm=italic
highlight LspErrorHighlight ctermfg=Red ctermbg=None
highlight LspErrorText ctermfg=Red ctermbg=None cterm=italic
highlight PMenu ctermfg=White ctermbg=None cterm=italic
highlight link markdownCode Identifier
