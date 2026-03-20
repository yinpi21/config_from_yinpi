" =====================
"   VIM CONFIG YINPI
" =====================
" Version épurée et commentée
" =============================

" --- Détection automatique du type de fichier et indentation adaptée ---
filetype plugin indent on

" --- Encodage universel ---
set encoding=utf-8          " Utilisation interne d'UTF-8
set fileencodings=          " Force UTF-8 à la lecture (pas de fallback latin1)
syntax on                   " Active la coloration syntaxique

" --- Spécifique Makefile ---
" Makefile exige de vraies tabulations, sinon la compilation échoue
autocmd Filetype make setlocal noexpandtab

" --- Intégration Git (config locale par repo) ---
" Exemple : git config vim.settings "expandtab sw=4 sts=4"
let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
    exe "set" git_settings
endif

" =====================
"   INTERFACE & CONFORT
" =====================
set number                  " Numéros de ligne
"set relativenumber          " (optionnel) Numéros relatifs utiles en mode normal
"set cursorline             " Surligne la ligne courante
set showmatch               " Montre le couple (), {}, []
set cc=80                   " Ligne guide à la colonne 80
set list                    " Montre tabulations et espaces inutiles
set listchars=tab:»·,trail:·
set scrolloff=10            " Garde 10 lignes visibles autour du curseur
set wildmenu                " Menu interactif pour complétion des commandes
set ruler                   " Montre position du curseur dans la barre d’état
set showcmd                 " Affiche les commandes en cours (mode normal)
set laststatus=2            " Barre d’état toujours visible
" Fond clair sur PC école (~/afs/ présent), sombre ailleurs

set mouse=a                 " Active la souris
set clipboard=unnamedplus   " Utilise le presse-papiers système

" =====================
"   INDENTATION
" =====================
set smartindent             " Indentation intelligente en C, etc.
set tabstop=4               " Largeur d'une tabulation à l'affichage
set shiftwidth=4            " Indentation automatique = 4 espaces
set expandtab               " Convertit les tabulations en espaces

" =====================
"   RECHERCHE
" =====================
set ignorecase              " Recherche insensible à la casse
set smartcase               " Sensible si majuscules dans la recherche
set incsearch               " Recherche incrémentale
set hlsearch                " Surligne toutes les correspondances
nnoremap <C-l> :noh<CR>     " Ctrl+L pour effacer le surlignage

" =====================
"   SAUVEGARDE / RELOAD
" =====================
set autowrite               " Sauvegarde automatique avant certaines commandes
set autoread                " Recharge auto si fichier modifié sur disque

" =====================
"   POSITION DU CURSEUR
" =====================
" Revient à la dernière position connue à la réouverture d’un fichier
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif

" =====================
"  Clang-Format
" =====================

function! FormatWithCursor()
  let l:save_cursor = getpos(".")
  silent execute '%!clang-format -style=file:' . expand('~/.config/clang-format/clang-format-c-current')
  call setpos('.', l:save_cursor)
endfunction

command! ClangFormat call FormatWithCursor()
command! Clang ClangFormat

" =====================
"   PLUGINS & DEBUG
" =====================
let g:termdebug_wide = 1    " Layout horizontal pour le débogueur intégré GDB

command! SessionEnd rightbelow vsplit ~/Templates/TEMPLATE_SESSION_NOTES.md

" ────────────────────────────────────────────────
" Souris activée et numéros visibles par défaut
" ────────────────────────────────────────────────
set mouse=a

" ────────────────────────────────────────────────
" F9 → mode “copie” : désactive souris et numéros
" F10 → mode “édition” : réactive tout
" ────────────────────────────────────────────────
"nnoremap <F9> :set mouse=<CR>:set nonumber norelativenumber<CR>:echo "📋 Mode copie activé (Ctrl+Shift+C/V disponibles)"<CR>
"nnoremap <F10> :set mouse=a<CR>:set number relativenumber<CR>:echo "🧭 Mode édition réactivé (souris & numéros visibles)"<CR>

nnoremap <F9> :set mouse=<CR>:set nonumber<CR>:echo "📋 Mode copie activé (Ctrl+Shift+C/V disponibles)"<CR>
nnoremap <F10> :set mouse=a<CR>:set number<CR>:echo "🧭 Mode édition réactivé (souris & numéros visibles)"<CR>


" Créer automatiquement les dossiers manquants à la sauvegarde
augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
