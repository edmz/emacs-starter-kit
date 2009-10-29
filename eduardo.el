;; ===========================================================================
;; defuns
;; ===========================================================================
(defun dont-kill-emacs ()
  (interactive)
  (error (substitute-command-keys "To exit emacs: \\[kill-emacs]")))

;; 
;; Hace que la linea actual se vaya hasta arriba
;; 
(defun curr-line-to-top-of-window ()
  "Scroll current line to top of window. Replaces three keystroke sequence C-u 0 C-l."
  (interactive)
  (recenter 0))


;;
;; Selecciona la palabra actual
;;
(defun select-curr-word ()
  "lbeh"
  (interactive)
  (backward-word)
  (mark-word '1))

;;
;; enjoy automatic indentation of yanked text in the listed programming modes
;; 
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode ruby-mode))
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

;; --------------------------------------------------------------------------
;; Convert from DOS > UNIX
(defun dos-unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))


;; --------------------------------------------------------------------------
;; Convert from UNIX > DOS
(defun unix-dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n")))

;;
;;
;;
(defun align-equals (start end)
  "make the first assignment operator on each line line up vertically"
  (interactive "*r")
  (save-excursion
    (save-restriction
      (let ((indent 0))
        (narrow-to-region start end)
        (beginning-of-buffer)
        (while (not (eobp))
          (if (find-assignment)
              (progn
                (exchange-point-and-mark)
                (setq indent (max indent (current-column)))
                (delete-horizontal-space)
                (insert " ")))
          (forward-line 1))
        (beginning-of-buffer)
        (while (not (eobp))
          (if (find-assignment)
              (indent-to-column (1+ (- indent  (- (mark) (point))))))
          (forward-line 1)))
      )))



(defun find-assignment ()
  (if (re-search-forward
       "[^<>=!]=\\|\\+=\\|-=\\|\\*=\\|/=\\|&=\\||=\\|\\^=\\|<<=\\|>>="
       (save-excursion (end-of-line) (point)) t)
      (progn
        (goto-char (match-beginning 0))
        (if (looking-at ".==")
            nil
          (if (looking-at "\\+=\\|-=\\|\\*=\\|/=\\|&=\\||=\\|\\^=\\|<<=\\|>>=")
              (set-mark (match-end 0))
            (forward-char 1)
            (set-mark (1+ (point))))
          (delete-horizontal-space)
          t))
    nil))

;; ===========================================================================
;; additions to starter-keybindings 
;; --------------------------------
;; 
;; redefine some keys to my own preferences
;; I have moved this one near to the end, because there are a lot of packages
;; which try to redefine keys. I'd like to have these:
;; ===========================================================================

(global-set-key [f2] 'goto-line)
(global-set-key [f8]         'increase-left-margin)
(global-set-key [(shift f8)]       'decrease-left-margin)
(global-set-key [(control f9)]      'desktop-save)
(global-set-key [(control f10)]      'desktop-read)
(global-set-key "\C-cw" 'delete-region) ; ala C-w and M-C-w
(global-set-key (kbd "<home>") 'back-to-indentation-or-beginning)
(global-set-key (kbd "<f3>") 'my-occur); grep buffers
(global-set-key [f5]      'my-next-occur)
(global-set-key [(meta control l)]     'curr-line-to-top-of-window)
(global-set-key [(meta o)]     'select-curr-word)
(global-set-key [(meta =)] 'align-equals)
(global-set-key [(f11)] 'query-replace)

;; keys that my keyboard doesn't provide by default
(global-set-key [(meta q)] "@")
(global-set-key [(meta ?')] "\\")
(global-set-key [(meta })] "`")
(global-set-key [(meta {)] "^")
(global-set-key [(meta +)] "~")


(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key [(meta control q)] 'fill-paragraph)

;(global-set-key [(meta -)] 'self-insert-command)

(global-set-key [(meta up)] 'chop-move-up) 
(global-set-key [(meta down)] 'chop-move-down) 

(global-set-key "\C-cn" 'next-error)  
(global-set-key "\C-cp" 'previous-error)

(define-key global-map (kbd "C-x C-_") 'redo)

;; dont kill eamcs
(global-set-key "\C-x\C-c" 'dont-kill-emacs)

(set-cursor-color "#666666")

;;
;; Applications
;;
(global-set-key (kbd "C-c s") (lambda () (interactive) (switch-or-start 'sql-mysql "*SQL*")))
(global-set-key (kbd "C-c r") (lambda () (interactive) (switch-or-start 'run-ruby "*ruby*")))
(global-set-key (kbd "C-c b") (lambda () (interactive) (switch-to-buffer "*bleh*")))


;;
;; Muse
;; 
(setq muse-project-alist
	  '(("Logical"			; my various writings
		 ("~/Documents/Work/logical/logical-docs" :default "index")
		 (:base "html" :path "~/Documents/Work/logical/logical-docs/html")
		 (:base "pdf" :path "~/Documents/Work/logical/logical-docs/pdfs")))
	  )




(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-delimiter-face ((t (:foreground "#999999"))))
 '(font-lock-comment-face ((t (:foreground "#999999"))))
 '(font-lock-constant-face ((t (:background "#f8f8ff" :foreground "#6666BB"))))
 '(font-lock-function-name-face ((t (:background "#333333" :foreground "#ffffff"))))
 '(font-lock-keyword-face ((t (:foreground "#660066" :weight bold))))
 '(font-lock-string-face ((t (:background "#fff8f8" :foreground "RosyBrown"))))
 '(highlight-current-line ((t (:background "cyan"))))
 '(highlight-current-line-face ((t (:background "#ffff99" :foreground "#333333"))))
 '(ibuffer-marked ((t (:foreground "red"))))
 '(ido-first-match ((t (:background "#666666" :foreground "yellow")))))



;;
;; org mode
;;
(setq org-agenda-files (list "~/Documents/global.org"
                             "~/Documents/Personal/donmenus-git/doc/donmenus.org"
                             "~/Documents/Work/logical/genio/docs/genio.org"
                             "~/Documents/Work/logical/logical.org"
                             "~/Documents/Romarios/romarios.org"))


(setq html-mode-hook 'turn-off-auto-fill)
(setq html-text-hook 'turn-off-auto-fill)
(setq xml-mode-hook 'turn-off-auto-fill)
(setq transient-mark-mode t)		;highlights selections
(set-default 'truncate-lines t)
(auto-fill-mode  -1)