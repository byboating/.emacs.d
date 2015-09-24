(defconst initial-buffer-choice-value "~/KuaiPan/Emacs/all.org" "启动时打开的buffer")
(defconst  default-directory-value "~/KuaiPan/Emacs/" "C-x C-f时的默认目录")

(defun add-subdirs-to-load-path (dir)
  "Recursive add directories to `load-path'."
  (let ((default-directory (file-name-as-directory dir)))
    (add-to-list 'load-path dir)
    (normal-top-level-add-subdirs-to-load-path)))
(add-subdirs-to-load-path "~/.emacs.d/site-lisp/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;init package;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Added by Package.el.  This must come before configurations installed packages.  
(require 'package)
;;emacs benchmark-init
(require 'benchmark-init-loaddefs)
(benchmark-init/activate)
;;org remote package-archives
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;;(add-to-list 'Info-default-directory-list "elisp/org-mode")
;;melpa
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;;Load Emacs Lisp packages, and activate them.
(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;init package;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;build-in variable and function;;;;;;;;;;;;;;;;;;;;;;;;;;
;;启动时最大化
(toggle-frame-maximized)
;;(toggle-frame-fullscreen)
;;use for emacsclient
(server-start)
;;melpa
(setq package-selected-packages (quote (dash company)))
;;自动配对
(electric-pair-mode 1)
;;(require 'autopair)
;;(autopair-global-mode) ;; enable autopair in all buffers
;;默认目录
(setq default-directory (symbol-value 'default-directory-value) )
;;以 y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(menu-bar-mode -1)
;滚动条
(scroll-bar-mode 1)
(which-function-mode 1)                 ;在mode line上显示当前光标在哪个函数体内部
(blink-cursor-mode -1)                  ;指针不闪动
;;(setq inhibit-startup-screen t)
(setq initial-buffer-choice (symbol-value 'initial-buffer-choice-value)) ;;值改为变量
(setq make-backup-files nil)            ;;禁用文件自动备份
;;auto-save
(setq auto-save-interval 5
      auto-save-timeout 3)
;;highlight current line 
(global-hl-line-mode 1)
(setq global-hl-line-sticky-flag 1);;默认值为nil
;; To customize the background color
;;(set-face-background 'hl-line "red")
;;设置光标类型
(set-default 'cursor-type 'bar)
;;设置visual-line-mode为全局的,一行字数超过当前窗口大小时换行显示
;;(add-hook 'text-mode-hook 'turn-on-visual-line-mode)全局visual-line-mode的另一种方式
;;(setq global-visual-line-mode t)全局无效
(global-visual-line-mode t)
;;让mode line显示列数(行数为默认显示)
(column-number-mode t)
;;; 在mode-line显示当前Buffer的大小
(size-indication-mode 1)
;;不要生成*~备份文件
(setq make-backup-files nil)
;;不要生成#*#备份文件
(setq auto-save-default nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;build-in variable and function;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;config external lisp;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'init-theme)
(require 'init-async)
(require 'init-helm)
(require 'init-company)
(require 'init-imenu-anywhere)
(require 'init-key)
(require 'init-undo-tree)
(require 'init-nlinum)
(require 'init-magit)
(require 'init-org)
(require 'init-highlight-parentheses)
(require 'init-tramp)
(require 'init-time-in-mode-line);;mode line显示当前时间
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;config external lisp;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;当前时间函数
(defun now-is ()
    "Display current time."
    (interactive)
    (message (format-time-string "Now is %Y-%m-%d %T")))
;; Ctrl-S-K delete line without kill
(defun delete-line ()
  (interactive)
  (delete-region
   (point)
   (save-excursion (move-end-of-line 1) (point)))
  (delete-char 1)
)
;;重定义C-W A-W 增加cut copy一行的功能
(defun cut-line-or-region ()
  "Cut the current line, or current text selection."
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (line-beginning-position) (line-beginning-position 2)) (message "cut-line-or-region")) )
(defun copy-line-or-region ()
  "Copy current line, or current text selection."
  (interactive)
  (if (use-region-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-beginning-position 2)) (message "copy-line-or-region")) )
;;kill-other-buffers
;;http://stackoverflow.com/questions/3417438/closing-all-other-buffers-in-emacs
(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))
