# Emacs — Cheatsheet

## Notation
| Symbole | Touche |
|---|---|
| `C-` | Ctrl |
| `M-` | Alt |
| `C-g` | **Annuler n'importe quoi** (réflexe n°1) |

---

## Fichiers & Buffers

> Dans Emacs, tu n'édites pas des fichiers — tu édites des **buffers** (un buffer peut être un fichier, un terminal, Magit, etc.)

| Raccourci | Action |
|---|---|
| `C-x C-f` | Ouvrir un fichier |
| `C-x C-s` | Sauvegarder |
| `C-x C-w` | Sauvegarder sous |
| `C-x b` | Changer de buffer |
| `C-x k` | Fermer un buffer |
| `C-x C-b` | Lister tous les buffers |

---

## Fenêtres (splits)

> Emacs appelle "window" ce qu'on appelle split, et "frame" ce qu'on appelle fenêtre.

| Raccourci | Action |
|---|---|
| `C-x 2` | Split horizontal |
| `C-x 3` | Split vertical |
| `C-x 0` | Fermer le split courant |
| `C-x 1` | Garder uniquement le split courant |
| `C-x o` | Passer au split suivant |

---

## Édition de base

| Raccourci | Action |
|---|---|
| `C-space` | Début de sélection |
| `C-w` | Couper la sélection |
| `M-w` | Copier la sélection |
| `C-y` | Coller |
| `C-/` | Annuler |
| `C-s` | Rechercher (puis `C-s` pour suivant) |
| `M-%` | Rechercher/remplacer |
| `M-g g` | Aller à la ligne N |
| `C-l` | Centrer l'écran sur le curseur |

---

## Ta config spécifique

| Raccourci | Action |
|---|---|
| `C-x g` | **Magit** — git status |
| `C-c f` | **Clang-format** EPITA sur le buffer |
| `C-c a` | **Org agenda** |
| `C-c c` | **Org capture** — ajouter une tâche rapide |
| `C-c e` | Ouvrir `init.el` |
| `C-h .` | Doc de la fonction sous le curseur (eglot) |

---

## Magit (les essentiels)

Lance avec `C-x g` dans un repo git.

| Touche | Action |
|---|---|
| `s` | Stage le fichier sous le curseur |
| `u` | Unstage |
| `c c` | Commit (puis `C-c C-c` pour valider) |
| `P p` | Push |
| `F p` | Pull |
| `b b` | Changer de branche |
| `b c` | Créer une branche |
| `l l` | Log |
| `q` | Fermer Magit |
| `?` | Aide — affiche toutes les commandes disponibles |

---

## Eglot / LSP

S'active automatiquement sur les `.c` / `.cpp`.

| Raccourci | Action |
|---|---|
| `M-.` | Aller à la définition |
| `M-,` | Revenir en arrière |
| `C-h .` | Documentation |
| `M-x eglot-rename` | Renommer un symbole |
| `M-x eglot-code-actions` | Actions contextuelles |

---

## Which-key

Tu n'as pas besoin de tout mémoriser. Tape n'importe quel préfixe (`C-x`, `C-c`, `M-x`...) et attends **0.5s** — la liste de tout ce qui est disponible s'affiche en bas.

---

## M-x — La commande universelle

Toutes les fonctions d'Emacs sont accessibles par leur nom via `M-x`. Avec **Vertico + Orderless** tu peux taper des mots dans n'importe quel ordre :

```
M-x mag sta   →  magit-status
M-x org cap   →  org-capture
```
