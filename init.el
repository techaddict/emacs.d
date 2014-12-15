(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize) ;; You might already have this line

;; ;; MAKE EMACS AWARE OF OSX $PATH, etc
;; ;; https://github.com/purcell/exec-path-from-shell
;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'solarized-dark t)


(add-to-list 'load-path "/home/piplup/emacs_files")
(require 'linum)
(global-linum-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(linum-format " %3d "))

;; make indentation commands use space only (never tab character)
(setq-default indent-tabs-mode nil) ; emacs 23.1, 24.2, default to t

;; set default tab char's display width to 2 spaces
(setq-default tab-width 2) ; emacs 23.1, 24.2, default to 8

(defun good-colors ()
  (progn
    (set-face-background 'region "brightblack"))
    (set-face-foreground 'region "color-231"
    ))
;; (good-colors)

(menu-bar-mode -1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(sml/setup)
(sml/apply-theme 'powerline)

(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; set the trigger key so that it can work together with yasnippet on tab key,
;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;; You can complete explicitly by typing M-TAB
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(set-face-background 'ac-candidate-face "brightblue")
(set-face-underline 'ac-candidate-face "blue")

(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;;;; Scala

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(add-hook 'scala-mode-hook '(lambda ()

                              ;; Bind the 'newline-and-indent' command to RET (aka 'enter'). This
                              ;; is normally also available as C-j. The 'newline-and-indent'
                              ;; command has the following functionality: 1) it removes trailing
                              ;; whitespace from the current line, 2) it create a new line, and 3)
                              ;; indents it.  An alternative is the
                              ;; 'reindent-then-newline-and-indent' command.
                              (local-set-key (kbd "RET") 'newline-and-indent)

                              ;; Alternatively, bind the 'newline-and-indent' command and
                              ;; 'scala-indent:insert-asterisk-on-multiline-comment' to RET in
                              ;; order to get indentation and asterisk-insertion within multi-line
                              ;; comments.
                              (local-set-key (kbd "RET")
                                             '(lambda ()
                                                (interactive)
                                                (newline-and-indent)
                                                (scala-indent:insert-asterisk-on-multiline-comment)))

                              ;; Bind the backtab (shift tab) to
                              ;; 'scala-indent:indent-with-reluctant-strategy command. This is usefull
                              ;; when using the 'eager' mode by default and you want to "outdent" a
                              ;; code line as a new statement.
                              (local-set-key (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)))

(add-hook 'sbt-mode-hook '(lambda ()
                            ;; compilation-skip-threshold tells the compilation minor-mode
                            ;; which type of compiler output can be skipped. 1 = skip info
                            ;; 2 = skip info and warnings.
                            (setq compilation-skip-threshold 1)

                            ;; Bind C-a to 'comint-bol when in sbt-mode. This will move the
                            ;; cursor to just after prompt.
                            (local-set-key (kbd "C-a") 'comint-bol)

                            ;; Bind M-RET to 'comint-accumulate. This will allow you to add
                            ;; more than one line to scala console prompt before sending it
                            ;; for interpretation. It will keep your command history cleaner.
                            (local-set-key (kbd "M-RET") 'comint-accumulate)))

(add-hook 'scala-mode-hook '(lambda ()
                              ;; sbt-find-definitions is a command that tries to find (with grep)
                              ;; the definition of the thing at point.
                              (local-set-key (kbd "M-.") 'sbt-find-definitions)

                              ;; use emacs M-x next-error to navigate errors
                              (local-set-key (kbd "M-'") 'next-error)
                              ;; use sbt-run-previous-command to re-compile your code after changes
                              (local-set-key (kbd "C-x '") 'sbt-run-previous-command)))

;; (add-hook 'scala-mode-hook '(lambda ()
;;                                (yas-minor-mode)))

;;;; Scala End

;; Shortcuts

;; Duplicate a Line
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")

;; Shortcut End

(delete-selection-mode +1)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; HELM
(defun load-helm ()
  ;; You can also start with M-x helm-mode and enjoy helm completion in your favourites Emacs commands
  ;; (e.g M-x, C-x C-f, etc...). You can enable this by adding in your init file
  ;; https://github.com/emacs-helm/helm
  ;; From http://tuhdo.github.io/helm-intro.html
  (helm-mode 1)
  (require 'helm-config)
  ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
  ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
  ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
        helm-buffers-fuzzy-matching           t ; fuzzy matching buffer names when non--nil
        helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
        helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
        helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
        helm-ff-file-name-history-use-recentf t))

(load-helm)
;; /HELM
                                        ; GIT
;; https://github.com/magit/magit
(define-key (current-global-map) (kbd "<f9>") 'magit-status)

;; PROJECTILE
;; Project management from emacs
;; http://batsov.com/projectile/
;; Load projectile for all modes (i.e., globally)
(projectile-global-mode)
;; MAC OSX SPECIFIC
;; Leverage the fairly unused Super key (by default Command on Mac keyboards and Windows on Win keyboards)
;;(define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
;;(define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
;;(define-key projectile-mode-map (kbd "C-x p") 'projectile-find-file)
;;(define-key projectile-mode-map [?\s-g] 'projectile-grep)
;; HELM AND PROJECTILE TIE IN
(global-set-key (kbd "C-x p") 'helm-projectile)

;; GOTO METHOD
(global-set-key (kbd "C-x C-m") 'imenu)

