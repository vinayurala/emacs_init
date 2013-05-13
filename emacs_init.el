(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
;; Set cursor to a vertical bar
(blink-cursor-mode 0)
(setq-default cursor-type 'bar)
;; Display date and time
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)
;; Display column number of the line
(setq column-number-mode t)
;; Prevent backup files(*~ files) from being created.
(setq make-backup-files nil)
;; Gtags init; I'm using exuberant-ctags now
(autoload 'gtags-mode "gtags" "" t)
;; auto-complete
(add-to-list 'load-path "/home/vinay/.emacs.d")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/vinay/.emacs.d/ac-dict")
(ac-config-default)
;;
(add-hook 'emacs-lisp-mode-hook
	  (function (lambda ()
		      (add-hook 'local-write-file-hooks
				'check-parens))))
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
  (setq path-to-ctags "ctags")
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

;; Function to kill all buffers except current
(defun kill-other-buffers ()
  "Kill all buffers except current."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
(message "Killed all other buffers"))

;; Compile current file using g++ / gcc
(defun compile-curr-file (output-file)
  (interactive (list (read-file-name "Output file name: ")))
  (setq final-output-file (file-name-nondirectory output-file))
  (setq curr-file (file-name-nondirectory buffer-file-name))
  (setq file-extn (file-name-extension curr-file))
  (if (string= "c" file-extn)
      (setq compiler-type "gcc")
    (setq compiler-type "g++"))
    (if  (string= final-output-file curr-file)
    	(setq final-output-file "a.out")
      (setq final-output-file output-file))
  (setq compile-output 
	(shell-command-to-string
	 (format "%s -g %s -o %s" compiler-type buffer-file-name final-output-file)))
  (if (string= "" compile-output) 
      (message "Compilation succeeded. Output file: %s" final-output-file)
  (message "%s" compile-output))
)

;; Insert closing braces in C/C++ files
(defun my-c-mode-insert-lcurly ()
  (interactive)
  (insert "{")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (c-indent-line)
      (insert "\n\n}")
      (c-indent-line)
      (forward-line -1)
      (c-indent-line))))

(eval-after-load 'cc-mode
  '(define-key c-mode-base-map "{" 'my-c-mode-insert-lcurly))

;; Insert closing paranthesis in C/C++ files
(defun my-c-mode-insert-lparan ()
  (interactive)
  (insert "(")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (insert ")")
      (forward-char -1))))

(eval-after-load 'cc-mode
  '(define-key c-mode-base-map "(" 'my-c-mode-insert-lparan))

;; Insert closing square brackets in C/C++ files
(defun my-c-mode-insert-lsquare ()
  (interactive)
  (insert "[")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (insert "]")
      (forward-char -1))))

(eval-after-load 'cc-mode
  '(define-key c-mode-base-map "[" 'my-c-mode-insert-lsquare))

;; Insert closing square brackets in C/C++ files
(defun my-c-mode-insert-langle ()
  (interactive)
  (insert "<")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (insert ">")
      (forward-char -1))))

(eval-after-load 'cc-mode
  '(define-key c-mode-base-map "<" 'my-c-mode-insert-langle))


;; Keyboard shortcuts

;; Kill-other-buffers
(global-set-key (kbd "C-x C-a C-b") 'kill-other-buffers)
;; Uncomment-region
(global-set-key (kbd "C-c u") 'uncomment-region)
;; compile-curr-file 
(global-set-key (kbd "C-x C-g") 'compile-curr-file)
;; Tag creation (ctags)
(global-set-key (kbd "C-x C-t") 'create-tags)
;; Compile (make -k)
(global-set-key (kbd "C-x C-m") 'compile)