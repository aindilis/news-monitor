(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu for Emacs 21):
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

;; (setq mew-mailbox-type 'mbox)

;; setup TLS encryption on al.<REDACTED>

(setq mew-imap-ssl t)
; (setq mew-imap-ssl-port "993")

(setq mew-proto "%")
(setq mew-imap-server "<REDACTED>")
(setq mew-ssl-verify-level 0)

(setq mew-config-alist
      '(
	("inbox"
	 ("inbox-folder"   . "%inbox")
	 ("imap-server"     . "<REDACTED>")
	 )
	("spam"
	 ("inbox-folder"   . "%spam")
	 ("imap-server"     . "<REDACTED>")
	 )
	("work"
	 ("inbox-folder"   . "%work")
	 ("imap-server"     . "<REDACTED>")
	 )
	("action"
	 ("inbox-folder"   . "%action")
	 ("imap-server"     . "<REDACTED>")
	 )
	("saved-messages"
	 ("inbox-folder"   . "%saved-messages")
	 ("imap-server"     . "<REDACTED>")
	 )
	)
      )

;; (setq mew-mbox-command-arg "-d /home/andrewdo/Maildir")

;; (setq mew-mailbox-type 'mbox)

;; ;; (setq mew-signature-as-lastpart nil)

;; (setq mew-mailbox-type nil)
;; (setq mew-pop-user "adougher9")
;; (setq mew-pop-server "pop.mail.yahoo.com")

;; (setq mew-pop-auth 'pass)

					; (load "/home/andrewdo/emacs-config/bbdb-mew-2.el")
					; (require 'bbdb-mew)
(setq mew-use-cached-passwd t)

					; (autoload 'bbdb-insinuate-mew "bbdb-mew"   "Hook BBDB into Mew")
;; (add-hook 'mew-draft-mode-newdraft-hook 'bbdb-insinuate-mew)

;; (defun mew-my-redefine-tab ()
;;  "redefine tab for mew"
;;  (define-key mew-draft-mode-map "\t" 'mail-mode-smart-tab)
;;  )
;; (add-hook 'mew-draft-mode-newdraft-hook 'mew-my-redefine-tab)

(add-hook 'mew-send-hook 'ispell-message)
(load "~/.emacs.d/mew-alias.el")

(require 'mew)
(defun mew-draft-header-comp ()
  ""
  (interactive)
  (mail-mode-smart-tab))
