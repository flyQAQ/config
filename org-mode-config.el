(require 'org)

(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cp" 'org-priority)

(setq org-agenda-files (quote ("~/Documents/org")))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
	      ("NEXT" :foreground "blue" :weight bold)
	      ("DONE" :foreground "forest green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("HOLD" :foreground "magenta" :weight bold)
	      ("CANCELLED" :foreground "forest green" :weight bold))))

(setq org-use-fast-todo-selection t)

(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("HOLD" ("WAITING") ("HOLD" . t))
	      (done ("WAITING") ("HOLD"))
	      ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-directory "~/Documents/org")
(setq org-default-notes-file "~/Documents/org/refile.org")

(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Documents/org/refile.org")
	       "* TODO %?\nSCHEDULED: %t\n"))))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

(setq org-refile-use-outline-path t)

(setq org-outline-path-complete-in-steps nil)

(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-completion-use-ido t)

(setq ido-everywhere t)

(setq ido-max-directory-size 100000)

(ido-mode (quote both))

(setq ido-default-file-method 'selected-window)

(setq ido-default-buffer-method 'selected-window)

(setq org-indirect-buffer-display 'current-window)

(defun rww/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'rww/verify-refile-target)

(setq org-agenda-dim-blocked-tasks nil)

(setq org-agenda-compact-blocks t)

(defun rww/skip-subtree-if-priority (priority)
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
	(pri-value (* 1000 (- org-lowest-priority priority)))
	(pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
	subtree-end
      nil)))

(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
	 ((tags "PRIORITY=\"A\""
		((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
		 (org-agenda-overriding-header "High-priority unfinished tasks:")))
	  (agenda "" ((org-agenda-ndays 1)))
	  (alltodo ""
		   ((org-agenda-skip-function '(or (rww/skip-subtree-if-priority ?A)
						   (org-agenda-skip-if nil '(scheduled deadline))))
		    (org-agenda-overring-header "ALL normal priority tasks:"))))
	 ((org-agenda-compact-blocks t)))))

(add-hook 'org-agenda-mode-hook
	  (lambda ()
	    (local-set-key (kbd "j") 'org-agenda-next-item)))
(add-hook 'org-agenda-mode-hook
	  (lambda ()
	    (local-set-key (kbd "k") 'org-agenda-previous-item)))


