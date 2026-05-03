;; TODO: organize all the personal settings
;;; $DO Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'zenburn)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;

;; Global Default ---
(setq +format-with 'prettier)
;; --- Language-Specific Rules ---
(setq-hook! 'python-mode-hook     +format-with 'black)
(setq-hook! 'js2-mode-hook        +format-with 'prettier)
(setq-hook! 'typescript-mode-hook +format-with 'prettier)
(setq-hook! 'kdl-mode-hook        +format-with 'kdlfmt)
(setq-hook! 'emacs-lisp-mode-hook +format-with 'lisp-indent)
(setq-hook! 'asm-mode-hook        +format-with 'asmfmt)

;; Making the window movements similar to nvim using Ctrl-h,j,k,l
(map! "C-h" #'evil-window-left
      "C-j" #'evil-window-down
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)

;; setting my own fonts
(setq doom-font (font-spec :family "Monaspace Krypton NF" :size 18 :weight 'regular)
      ;; Using the same family for symbols ensures icons align with the pixel grid
      doom-symbol-font (font-spec :family "Monaspace Krypton NF"))

;; Enabling ligatures
(setq +ligatures-extras-in-modes '(org-mode mhtml-mode masm-mode))


;; Making a sidebar for file directories
;; customizations for treemacs

(defun my/treemacs-toggle()
  (interactive)
  (require 'treemacs)
  (pcase (treemacs-current-visibility)
    ('visible (delete-window (treemacs-get-local-window)))
    (_ (treemacs-add-and-display-current-project))))

(map! :leader
      :desc "Toggle treemacs" "e" #'my/treemacs-toggle())

(after! treemacs
  (map! :map treemacs-mode-map
        :m "h" #'treemacs-goto-parent-node
        :m "l" #'treemacs-RET-action
        :m "H" #'treemacs-collapse-parent-node
        :m "L" #'treemacs-root-down
        :m "a" #'treemacs-create-file ; or treemacs-create-directory
        :m "d" #'treemacs-delete-file
        :m "D" (lambda () (interactive)
                 (let ((treemacs-confirm-flags nil))
                   (treemacs-remove-project-from-workspace)))
        :m "r" #'treemacs-rename-file
        :m "c" #'treemacs-copy-file
        :m [backspace] #'treemacs-goto-parent-node)
  (add-hook 'treemacs-mode-hook
            (lambda ()
              ;; Set the shape for standard Emacs
              (setq-local cursor-type '(hbar . 5))
              ;; Set the COLOR (Light Orange) and SHAPE for Evil Mode
              (setq-local evil-normal-state-cursor '("#FFB347" hbar)
                          evil-insert-state-cursor '("#FFB347" hbar)
                          evil-visual-state-cursor '("#FFB347" hbar)
                          evil-motion-state-cursor '("#FFB347" hbar))))
  (setq treemacs-width-is-initially-locked nil
        treemacs-width 25
        treemacs-is-never-other-window t
        treemacs-sorting 'alphabetic-case-insensitive-asc
        treemacs-show-hidden-files t
        treemacs-project-follow-cleanup t
        treemacs-follow-mode t
        treemacs-filewatch-mode t
        treemacs-fringe-indicator-mode t))

;; Shows the saved message everytime Ctrl-s is pressed
(defun my-force-save-and-message ()
  "Format the buffer, save it, and display a confirmation message."
  (interactive)
  (let ((evil-move-cursor-back nil))
    ;; Using call-interactively handles the arguments for us
    (when (fboundp '+format/buffer)
      (call-interactively #'+format/buffer))
    (save-buffer)
    (message "File formatted & saved successfully!")
    (when (fboundp 'evil-normal-state)
      (evil-normal-state))))

;; custom keymapping for saving the file (same as nvim)
(map! "C-s" #'my-force-save-and-message)


;;  Bind SPC 1-5 to Workspace switching
;; make worksapces to have multiple files in different workspaces, each workspace will have its own (visible) buffers (tabs)
(map! :leader
      :desc "Workspace 1" "1" #'(lambda () (interactive) (+workspace/switch-to 0))
      :desc "Workspace 2" "2" #'(lambda () (interactive) (+workspace/switch-to 1))
      :desc "Workspace 3" "3" #'(lambda () (interactive) (+workspace/switch-to 2))
      :desc "Workspace 4" "4" #'(lambda () (interactive) (+workspace/switch-to 3))
      :desc "Workspace 5" "5" #'(lambda () (interactive) (+workspace/switch-to 4)))

;; Bind Keys to move between tabs (Like Nvim bufferline)
;; Shift H and L to move through the file tabs
(map! :n "H" #'centaur-tabs-backward
      :nvi "C-<iso-lefttab>" #'centaur-tabs-backward
      :n "L" #'centaur-tabs-forward
      :nvi "C-<tab>" #'centaur-tabs-forward)


;; Configure Centaur Tabs to be "Workspace Aware"
(after! centaur-tabs
  (centaur-tabs-mode 1)
  (setq centaur-tabs-set-bar 'over
        centaur-tabs-set-icons t
        centaur-tabs-height 32
        ;; This tells it to group by project/workspace
        centaur-tabs-set-modified-marker t
        centaur-tabs-buffer-groups-function #'centaur-tabs-project-groups)

  ;; This part makes sure tabs are scoped to the current DOOM workspace
  (defun my-tabs-buffer-groups ()
    (list (or (bound-and-true-p +workspace--current-name) "Default")))

  (setq centaur-tabs-buffer-groups-function #'my-tabs-buffer-groups))


;; customizing the bottom info horizontal bar (modeline)
(after! doom-modeline
  (require 'battery)
  (require 'time)
  (display-battery-mode 1)
  (display-time-mode 1)

  (setq display-time-format "%a %d %b %I:%M %p"   ; e.g. "Sun 02 Mar 02:56 PM"
        display-time-default-load-average nil
        doom-modeline-battery t
        doom-modeline-persp-name t
        doom-modeline-time t
        doom-modeline-bar-width 10
        display-time-interval 60)

  ;; Custom layout:
  ;; Left:  most important file info → position → time (≈ center)
  ;; Right: battery first → then LSP / major-mode / git / checks
  (doom-modeline-def-modeline 'main
    '(bar " " buffer-info persp-name "                                           "   time)
    '(battery lsp major-mode vcs check remote-host)))


;; masm-mode for .asm files
(add-to-list 'auto-mode-alist '("\\.asm\\'" . masm-mode))

;; making repl screen appear on the right side
(after! sly
  ;; More precise regex: matches *sly-mrepl for anything*
  (set-popup-rule! "^\\*sly-mrepl.*\\*$"
    :side 'right
    :size 0.35          ; 35% width feels good for REPL
    :width 0.35         ; explicit width (sometimes helps)
    :vslot 2            ; higher vslot = more to the right if multiple side popups
    :slot 2             ; helps stacking order
    :quit nil           ; don't close on ESC/q
    :select t           ; focus it when it opens
    :modeline t))       ; show modeline (optional, looks better)

;; AI Integration
(after! codeium
  (setq use-dialog-box nil)

  (setq codeium/metadata/api_key "ott$IEinHEWEEPWI-fvfHTMZry1eZAQ-qTD3s-FVq7e5Z08")

  (map! :map codeium-active-mode-map
        "<tab>" #'codeium-accept-completion
        [tab] #'codeium-accept-completion
        "C-g" #'codeium-dismiss-completion)
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point t))

;; running lisp files quicker
(defun my/lisp-save-and-run ()
  (interactive)
  (when (and (derived-mode-p 'lisp-mode)
             (buffer-file-name))
    (save-buffer)
    (if (sly-connected-p)
        (progn
          (sly-load-file (buffer-file-name))
          (message "Lisp file loaded"))
      (message "Sly not connected — M-x sly"))))

;; Keybinding (using evil-collection / general / doom style map!)
(map! :map lisp-mode-map
      :n "<f5>" #'my/lisp-save-and-run
      :i "<f5>" #'my/lisp-save-and-run)

;; clearing the repl output
(defun my/sly-clear-full-repl ()
  "Clear the entire SLY REPL buffer (equivalent to C-c M-o inside the REPL)."
  (interactive)
  (if (sly-connected-p)
      (let ((repl-buffer (save-window-excursion
                           (sly-mrepl)  ; switches to REPL temporarily and returns it
                           (current-buffer))))
        (with-current-buffer repl-buffer
          (sly-mrepl-clear-repl))   ; safe now because we're in the REPL buffer
        (message "Full REPL cleared"))
    (message "SLY is not connected — run M-x sly first")))

;; Your Doom-style binding
(map! :map lisp-mode-map
      :n "<f6>" #'my/sly-clear-full-repl
      :i "<f6>" #'my/sly-clear-full-repl)


(defun my/run-masm-dosbox ()
  "Assemble MASM code and run it in DOSBox-X, bypassing path issues."
  (interactive)
  (save-buffer)
  (let* ((file-path (buffer-file-name))
         (dir (file-name-directory file-path))
         (file-name (file-name-nondirectory file-path))
         (out-name "PROG.EXE"))
    ;; We use 'default-directory' to force Emacs to run the command inside the folder
    (let ((default-directory dir))
      ;; -mz: DOS EXE format
      ;; -nologo: Clean output
      ;; -fo: Force output to 'PROG.EXE'
      (if (zerop (shell-command (format "jwasm -mz -nologo -fo %s %s"
                                        out-name
                                        (shell-quote-argument file-name))))
          (start-process "dosbox-x" nil "dosbox-x"
                         "-quiet"
                         "-c" (format "mount c \"%s\"" dir)
                         "-c" "c:"
                         "-c" out-name)
        (message "Assembly failed! Check the *Messages* buffer for JWasm errors.")))))

;; Bind it to 'SPC c r'
(map! :map asm-mode-map
      :leader
      :desc "Run MASM in DOSBox" "c r" #'my/run-masm-dosbox)

(setq sly-lisp-implementations
      '((sbcl ("sbcl" "--dynamic-space-size" "2600"))))


;; ASM mode
(add-to-list 'auto-mode-alist '("\\.asm\\'" .asm-mode))
(add-to-list 'auto-mode-alist '("\\.s\\'" .asm-mode))
(setq asm-comment-char ?\;)
