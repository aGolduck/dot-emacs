;;; -*- lexical-binding: t; -*-
;;; w-hermes-todo.el --- Conditional hermes-todo integration
;;
;;; Commentary:
;; This module activates ONLY when hermes-todo directory exists.
;; It connects Emacs to the AI-managed org-mode GTD system.
;; On machines without hermes-todo, this file loads silently with no effect.

(defvar w/hermes-todo-dir "/data/home/bingezhou/s/hermes-todo"
  "Path to hermes-todo repository.
Override this in private.el if your setup is different.")

(defvar w/hermes-todo-file (expand-file-name "todo.org" w/hermes-todo-dir)
  "The main todo.org file.")

(defvar w/hermes-todo-scripts-dir
  (expand-file-name "lisp/hermes-scripts" user-emacs-directory)
  "Directory containing batch elisp scripts.
Canonical location under .emacs.d; hermes-todo/scripts is a symlink to here.")

(defvar w/hermes-todo--active nil
  "Non-nil when hermes-todo integration is active.")

;; ───────────────────────────────────────────────────────────
;; Activation guard
;; ───────────────────────────────────────────────────────────

(when (and (file-directory-p w/hermes-todo-dir)
           (file-exists-p w/hermes-todo-file))
  (setq w/hermes-todo--active t)

  ;; ── Org integration ──
  (setq org-directory w/hermes-todo-dir)
  (with-eval-after-load 'org
    (add-to-list 'org-agenda-files w/hermes-todo-file))

  ;; Set default notes file to todo.org
  (with-eval-after-load 'org
    (setq org-default-notes-file w/hermes-todo-file))

  ;; ── Auto-revert for AI co-editing ──
  (add-hook 'org-mode-hook
            (lambda ()
              (when (and buffer-file-name
                         (string-equal (file-truename buffer-file-name)
                                       (file-truename w/hermes-todo-file)))
                (auto-revert-mode 1)
                (message "[hermes] auto-revert enabled for todo.org"))))

  ;; ── Capture template ──
  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 `("h" "Hermes Inbox" entry
                   (file+headline ,w/hermes-todo-file "inbox")
                   "** TODO %?\n:PROPERTIES:\n:AI_ACTION: capture\n:ENERGY: medium\n:TIME: 15min\n:END:\n%i\n%a")))

  ;; ── Script runner ──
  (defun w/hermes-run-script (&optional script)
    "Run a batch elisp script from hermes-todo/scripts/ on todo.org.
If SCRIPT is nil, prompt with completion."
    (interactive)
    (unless (file-directory-p w/hermes-todo-scripts-dir)
      (user-error "[hermes] scripts directory not found: %s" w/hermes-todo-scripts-dir))
    (let* ((scripts (directory-files w/hermes-todo-scripts-dir nil "\\.el$"))
           (choice (or script (completing-read "Hermes script: " scripts nil t))))
      (unless (member choice scripts)
        (user-error "[hermes] unknown script: %s" choice))
      (message "[hermes] Running %s..." choice)
      (let ((output
             (shell-command-to-string
              (format "emacs --batch -l %s %s 2>&1"
                      (shell-quote-argument (expand-file-name choice w/hermes-todo-scripts-dir))
                      (shell-quote-argument w/hermes-todo-file)))))
        (message "[hermes] %s done" choice)
        (when (> (length output) 0)
          (with-output-to-temp-buffer "*hermes-output*"
            (princ output))))))

  ;; ── Git helpers ──
  (defun w/hermes-todo--git-cmd (args &optional msg)
    "Run git command in hermes-todo directory."
    (let ((default-directory w/hermes-todo-dir))
      (if msg (message "[hermes] %s..." msg))
      (shell-command-to-string (format "git %s 2>&1" args))))

  (defun w/hermes-todo-git-status ()
    "Check git status of todo.org."
    (interactive)
    (let ((output (w/hermes-todo--git-cmd "status --short todo.org" "checking status")))
      (if (string-empty-p output)
          (message "[hermes] todo.org is clean")
        (message "[hermes] Uncommitted changes:\n%s" output))))

  (defun w/hermes-todo-commit ()
    "Stage and commit todo.org."
    (interactive)
    (let ((output (w/hermes-todo--git-cmd "add todo.org && git commit -m 'emacs: edit todo.org'"
                                           "committing")))
      (message "[hermes] %s" (string-trim output))))

  (defun w/hermes-todo-pull ()
    "Pull latest changes from remote."
    (interactive)
    (let ((output (w/hermes-todo--git-cmd "pull" "pulling")))
      (message "[hermes] %s" (string-trim output))))

  ;; ── Dirty check (for AI safety) ──
  (defun w/hermes-todo-dirty-p ()
    "Return non-nil if todo.org has uncommitted changes."
    (not (string-empty-p
          (w/hermes-todo--git-cmd "diff --quiet todo.org || echo dirty"))))

  ;; ── Keybindings ──
  (global-set-key (kbd "M-SPC t s") #'w/hermes-run-script)
  (global-set-key (kbd "M-SPC t g") #'w/hermes-todo-git-status)
  (global-set-key (kbd "M-SPC t c") #'w/hermes-todo-commit)
  (global-set-key (kbd "M-SPC t p") #'w/hermes-todo-pull)

  (message "[hermes] todo integration active: %s" w/hermes-todo-dir))

(provide 'w-hermes-todo)
;;; w-hermes-todo.el ends here
