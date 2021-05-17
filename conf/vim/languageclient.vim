" Disable these to get language client logging.
let g:LanguageClient_loggingFile="/tmp/neovim-lang-client.log"
let g:LanguageClient_loggingLevel="INFO"

set hidden

let g:LanguageClient_autoStart=1
let g:LanguageClient_loadSettings=1
let g:LanguageClient_selectionUI="fzf"
let g:LanguageClient_settingsPath="/home/ben/.files/conf/language-client-settings.json"
let g:LanguageClient_useVirtualText = "All"
let g:LanguageClient_virtualTextPrefix = "=> "

let g:LanguageClient_serverCommands = {}

if executable('svelteserver')
    let g:LanguageClient_serverCommands['svelte'] = ['svelteserver', '--stdio']
endif

if executable('rust-analyzer')
    let g:LanguageClient_serverCommands['rust'] = {
        \ "name": "rust-analyzer",
        \ "command": ["rust-analyzer", '--log-file=/tmp/ra.log'],
        \ 'initializationOptions' : {
        \   'inlayHints': {
        \       'enable': v:true,
        \       'chainingHints': v:true,
        \       'parameterHints': v:true,
        \       'typeHints': v:true,
        \   }
        \  },
        \ }
endif

if executable('typescript-language-server')
    let g:LanguageClient_serverCommands['javascript'] = ['typescript-language-server', '--stdio']
    let g:LanguageClient_serverCommands['typescript'] = ['typescript-language-server', '--stdio']
    let g:LanguageClient_serverCommands['typescript.tsx'] = ['typescript-language-server', '--stdio']
    let g:LanguageClient_serverCommands['typescriptreact'] = ['typescript-language-server', '--stdio']
elseif executable('javascript-typescript-stdio')
    let g:LanguageClient_serverCommands['javascript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript.tsx'] = ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescriptreact'] = ['javascript-typescript-stdio']
endif

if executable('ccls')
    let g:LanguageClient_serverCommands['cpp'] = ['ccls']
elseif executable('cquery')
    let g:LanguageClient_serverCommands['cpp'] = [
        \ 'cquery',
        \  '--log-file=/tmp/cq.log',
        \  '--init={"cacheDirectory":"/home/ben/.cache/cquery"}'
    \ ]
elseif executable('clangd')
    let g:LanguageClient_serverCommands['cpp'] = ['clangd']
endif

if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif

let g:LanguageClient_rootMarkers = {
    \ 'typescript': ['tsconfig.json']
    \ }

nmap <silent> <leader>m <Plug>(lcn-menu)
nmap <silent> <leader>r <Plug>(lcn-references)
nmap <silent> <leader>R <Plug>(lcn-rename)
nmap <silent> <leader>d <Plug>(lcn-definition)
nmap <silent> <leader>i <Plug>(lcn-implementation)
nmap <silent> <leader>f <Plug>(lcn-format)
nmap <silent> <leader>t <Plug>(lcn-type-definition)
nnoremap <silent> <leader>s :call LanguageClient_workspace_symbol()<CR>
nmap <silent> <leader>e <Plug>(lcn-explain-error)
nmap <silent> <leader>h <Plug>(lcn-hover)
nmap <silent> <leader>a <Plug>(lcn-code-action)
nmap <silent> <leader>A <Plug>(lcn-code-lens-action)

let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" Display the LSP message in the bottom left.
function! CustomLspLine() abort
  if get(b:, 'LanguageClient_isServerRunning', 0) ==# 0
    return ''
  endif
  let l:diagnosticsDict = LanguageClient#statusLineDiagnosticsCounts()
  let l:errors = get(l:diagnosticsDict,'E',0)
  let l:warnings = get(l:diagnosticsDict,'W',0)
  let l:prefix = l:errors + l:warnings == 0 ? "✔ " : "🔴: " . l:errors . "/ ⚠️:" . l:warnings . " "
  let l:status = LanguageClient#serverStatus() == 0 ? "(idle)" : "(busy)"
  return l:prefix . l:status . LanguageClient#serverStatusMessage()
endfunction

call airline#parts#define_function('show_lsp_status', 'CustomLspLine')
let g:airline_section_b = airline#section#create_right(['show_lsp_status'])
