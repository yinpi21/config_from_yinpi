;;; init.el --- Configuration Emacs — yinpi

;; ─────────────────────────────────────────────────────────────────────
;; 1. PERFORMANCES AU DÉMARRAGE
;;    Augmente le seuil GC pendant le chargement, puis le remet.
;;    Évite des centaines de GC inutiles à chaque démarrage.
;; ─────────────────────────────────────────────────────────────────────

(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; ─────────────────────────────────────────────────────────────────────
;; 2. PAQUETS — MELPA + USE-PACKAGE
;;    use-package est builtin depuis Emacs 29.
;;    :ensure t = installe automatiquement depuis MELPA si absent.
;; ─────────────────────────────────────────────────────────────────────

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; ─────────────────────────────────────────────────────────────────────
;; 3. UI — NETTOYAGE ET APPARENCE
;; ─────────────────────────────────────────────────────────────────────

;; Supprime les barres d'outils inutiles
(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; Modus-themes : builtin depuis Emacs 28, excellent contraste.
;; modus-vivendi = dark / modus-operandi = light (comme kitty-toggle-theme)
(load-theme 'modus-vivendi t)

;; Police identique à kitty pour la cohérence visuelle
(set-face-attribute 'default nil :family "NotoSansMono" :height 120)

;; Numéros de ligne relatifs dans tous les buffers de code
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Indicateur de colonne 80
(setq-default fill-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Parenthèses correspondantes immédiatement
(show-paren-mode t)
(setq show-paren-delay 0)

;; Pas de bip sonore
(setq ring-bell-function 'ignore)

;; Affiche le numéro de colonne dans la modeline
(column-number-mode t)

;; ─────────────────────────────────────────────────────────────────────
;; 4. COMPORTEMENT GÉNÉRAL
;; ─────────────────────────────────────────────────────────────────────

;; UTF-8 partout
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; Espaces, pas de tabs — cohérent avec .vimrc
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; La frappe remplace la sélection (comportement standard)
(delete-selection-mode t)

;; Recharge les fichiers modifiés sur disque automatiquement
(global-auto-revert-mode t)
(setq auto-revert-verbose nil)

;; y/n au lieu de yes/no
(setopt use-short-answers t)

;; Scroll smooth : ne jump pas de moitié de page
(setq scroll-conservatively 101
      scroll-margin 5)

;; Place les fichiers de sauvegarde dans ~/.emacs.d/ — pas dans tes projets
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))
(make-directory (expand-file-name "backups/"   user-emacs-directory) t)
(make-directory (expand-file-name "auto-saves/" user-emacs-directory) t)

;; Évite de polluer init.el avec les customizations via M-x customize
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

;; ─────────────────────────────────────────────────────────────────────
;; 5. WHICH-KEY (builtin depuis Emacs 30)
;;    Affiche les keybindings disponibles après une touche préfixe.
;;    Indispensable pour apprendre les raccourcis Emacs.
;; ─────────────────────────────────────────────────────────────────────

(which-key-mode t)
(setq which-key-idle-delay 0.5)

;; ─────────────────────────────────────────────────────────────────────
;; 6. COMPLÉTION DANS LE MINIBUFFER
;;    vertico    = UI verticale (remplace l'affichage horizontal par défaut)
;;    orderless  = matching fuzzy — tape des mots dans n'importe quel ordre
;;    marginalia = annotations dans les listes (type de commande, doc, etc.)
;; ─────────────────────────────────────────────────────────────────────

(use-package vertico
  :init (vertico-mode t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode t))

;; ─────────────────────────────────────────────────────────────────────
;; 7. COMPLÉTION DANS LE BUFFER (corfu)
;;    Popup de complétion inline, léger, moderne.
;;    Fonctionne avec eglot (LSP) et le système builtin de complétion.
;; ─────────────────────────────────────────────────────────────────────

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.4)
  (corfu-auto-prefix 2)       ; déclenche après 2 caractères
  (corfu-quit-no-match t)     ; ferme si aucun match
  (corfu-preview-current nil) ; pas de preview automatique
  :init (global-corfu-mode t))

;; ─────────────────────────────────────────────────────────────────────
;; 8. MAGIT
;;    C-x g → magit-status (point d'entrée principal)
;;    Apprends les touches depuis l'interface : ? affiche l'aide
;; ─────────────────────────────────────────────────────────────────────

(use-package magit
  :bind ("C-x g" . magit-status))

;; ─────────────────────────────────────────────────────────────────────
;; 9. EGLOT (LSP — builtin)
;;    Démarre clangd automatiquement sur les fichiers C/C++.
;;    Prérequis : clangd installé (paquet clang ou clang-tools)
;; ─────────────────────────────────────────────────────────────────────

(add-hook 'c-mode-hook   #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)

;; ─────────────────────────────────────────────────────────────────────
;; 10. CLANG-FORMAT EPITA
;;     Formatage manuel via C-c f (comme :Clang dans vim).
;;     Utilise le symlink clang-format-c-current → année en cours.
;;     Écrit dans un fichier tmp pour ne pas corrompre le buffer si erreur.
;; ─────────────────────────────────────────────────────────────────────

(defun clang-format-epita ()
  "Formate le buffer avec le style clang-format EPITA (C-c f)."
  (interactive)
  (let ((style (expand-file-name "~/.config/clang-format/clang-format-c-current")))
    (unless (file-exists-p style)
      (error "Style introuvable : %s" style))
    (let ((tmp (make-temp-file "emacs-clang-" nil ".c"))
          (pos (point)))
      (unwind-protect
          (progn
            (write-region nil nil tmp nil 'silent)
            (if (zerop (call-process "clang-format" nil nil nil
                                     "-i"
                                     (format "-style=file:%s" style)
                                     tmp))
                (progn
                  (insert-file-contents tmp nil nil nil t)
                  (goto-char pos)
                  (message "Formaté avec le style EPITA."))
              (message "clang-format a échoué — buffer inchangé.")))
        (delete-file tmp)))))

(global-set-key (kbd "C-c f") #'clang-format-epita)

;; ─────────────────────────────────────────────────────────────────────
;; 11. ORG-MODE — AGENDA ET CAPTURE
;;     Org-mode est builtin. On ne l'installe pas (:ensure nil).
;;     Les fichiers org vivent dans ~/org/, séparés d'Obsidian.
;;
;;     Raccourcis principaux :
;;       C-c a → agenda
;;       C-c c → capture rapide (ajouter une tâche sans quitter ce qu'on fait)
;;       C-c t → changer l'état d'une tâche (TODO → IN-PROGRESS → DONE)
;; ─────────────────────────────────────────────────────────────────────

(make-directory "~/org" t)

(use-package org
  :ensure nil
  :custom
  (org-directory "~/org")
  (org-agenda-files '("~/org/agenda.org" "~/org/school.org"))
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(p!)" "WAITING(w@)" "|" "DONE(d!)" "CANCELLED(c@)")))
  (org-log-done 'time)           ; timestamp automatique quand DONE
  (org-hide-emphasis-markers t)  ; masque *bold* /italic/ etc.
  (org-startup-indented t)       ; indentation visuelle des headers
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)))

;; Templates de capture rapide
(setq org-capture-templates
      '(("t" "Tâche générale" entry
         (file+headline "~/org/agenda.org" "Tâches")
         "* TODO %?\n  Créé : %U\n")
        ("s" "Tâche école" entry
         (file+headline "~/org/school.org" "École")
         "* TODO %? :school:\n  DEADLINE: %^{Deadline}t\n  Créé : %U\n")
        ("n" "Note rapide" entry
         (file+headline "~/org/agenda.org" "Notes")
         "* %?\n  %U\n")))

;; ─────────────────────────────────────────────────────────────────────
;; 12. RACCOURCIS PERSONNELS
;; ─────────────────────────────────────────────────────────────────────

;; Ouvre ce fichier rapidement
(global-set-key (kbd "C-c e")
                (lambda () (interactive) (find-file user-init-file)))

;; ─────────────────────────────────────────────────────────────────────
;; Pour aller plus loin quand tu seras à l'aise :
;;   - consult.el  : recherche avancée (grep, ripgrep, buffers...)
;;   - embark.el   : actions contextuelles sur n'importe quoi
;;   - org-roam    : notes liées façon Obsidian mais dans Emacs
;;   - dired       : gestionnaire de fichiers (builtin, très puissant)
;; ─────────────────────────────────────────────────────────────────────

;;; init.el ends here
