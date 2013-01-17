(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
;; Prevent backup files(*~ files) from being created.
(setq make-backup-files nil)
;; Gtags init; I'm using exuberant-ctags now
(autoload 'gtags-mode "gtags" "" t)
(auto-insert-mode)
;; C++ skeleton (C++ template from which a C++ file is created)
(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(CC?\\|cc\\|cxx\\|cpp\\|c++\\)\\'" . "C++ skeleton")
     '( \n
       "#include <iostream>" \n \n
       "using namespace std;" \n \n
       "int main()" \n
       "{" \n
       > _ \n
       "cout<<endl;" \n
       "return 0;" \n
       "}" > \n)))
;; C - skeleton
(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.c\\'" . "C skeleton")
     '( \n
       "#include <stdio.h>" \n \n
       "int main()" \n
       "{" \n
       > _ \n
       "printf(\"\\n\");" \n
       "return 0;" \n
       "}" > \n)))
;; ctags -e from emacs prompt. Use M-x create-tags
  (setq path-to-ctags "ctags") ;; <- your ctags path here
  (defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f %s/TAGS -e -R %s --exclude=.git" path-to-ctags dir-name (directory-file-name dir-name)))
    (message "Tags created successfully!")
  )
;; Open in maximized window, by default
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)
(defun kill-other-buffers ()
  "Kill all buffers except current."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
(message "Killed all other buffers"))
(defun compile-curr-file ()
  (interactive)
  (funcall 'compile 'buffer-file-name))

;; Keyboard shortcut; closes all buffers except current one. 
;; See prev function for definition
(global-set-key (kbd "C-x C-a C-b") 'kill-other-buffers)
;; C-c C-u is already taken; hence going with 'C-c u'
(global-set-key (kbd "C-c u") 'uncomment-region)
;; Compile shortcut
(global-set-key (kbd "C-c C-g") 'compile-curr-file)
;; Shortcut for tag creation 'C-c C-t'
(global-set-key (kbd "C-c C-t") 'create-tags)
