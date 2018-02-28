(require 'gnus)

(defun news-monitor (&optional arg dont-connect slave)
  "Read network news.
If ARG is non-nil and a positive number, Gnus will use that as the
startup level.  If ARG is non-nil and not a positive number, Gnus will
prompt the user for the name of an NNTP server to use."
  (interactive "P")
  ;; When using the development version of Gnus, load the gnus-load
  ;; file.
  (unless (string-match "^Gnus" gnus-version)
    (load "gnus-load" nil t))
  (unless (byte-code-function-p (symbol-function 'gnus))
    (message "You should byte-compile Gnus")
    (sit-for 2))
  (let ((gnus-action-message-log (list nil)))
    (gnus-1 arg dont-connect slave)
    (gnus-final-warning))
 (news-monitor-group-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Group Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode news-monitor-group-mode
 gnus-group-mode "News-Monitor-Group"
 "Major mode for asserting knowledge about news, Group mode.
\\{gnus-summary-mode-map}"
 (define-key news-monitor-group-mode-map "\r" 'news-monitor-group-select-group)
 )

(defun news-monitor-group-select-group (&optional all)
 "Select this newsgroup.
No article is selected automatically.
If the group is opened, just switch the summary buffer.
If ALL is non-nil, already read articles become readable.
If ALL is a positive number, fetch this number of the latest
articles in the group.
If ALL is a negative number, fetch this number of the earliest
articles in the group."
 (interactive "P")
 (when (and (eobp) (not (gnus-group-group-name)))
  (forward-line -1))
 (gnus-group-read-group all t)
 (news-monitor-summary-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Summary Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode news-monitor-summary-mode
 gnus-summary-mode "News-Monitor-Summary"
 "Major mode for asserting knowledge about news, Summary mode.
\\{gnus-summary-mode-map}"
 (define-key news-monitor-summary-mode-map "\r" 'news-monitor-summary-scroll-up)
 )

(defun news-monitor-summary-scroll-up (lines)
  "Scroll up (or down) one line current article.
Argument LINES specifies lines to be scrolled up (or down if negative).
If no article is selected, then the current article will be selected first."
  (interactive "p")
  (gnus-configure-windows 'article)
  (gnus-summary-show-thread)
  (when (eq (gnus-summary-select-article nil nil 'pseudo) 'old)
    (gnus-eval-in-buffer-window gnus-article-buffer
      (cond ((> lines 0)
	     (when (gnus-article-next-page lines)
	       (gnus-message 3 "End of message")))
	    ((< lines 0)
	     (gnus-article-prev-page (- lines))))
     ;; (news-monitor-article-mode)
     )
   )
  (gnus-summary-recenter)
  (gnus-summary-position-point))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Article Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode news-monitor-article-mode
 gnus-article-mode "News-Monitor-Article"
 "Major mode for asserting knowledge about news, Article mode.
\\{gnus-article-mode-map}"
 (define-key news-monitor-article-mode-map "\r" 'news-monitor-article-mode-browse-url)
 )

(defun news-monitor-article-mode-browse-url ()
 "Browse the URL under point."
 (interactive)
 (let ((url (get-text-property (point) 'shr-url)))
  (cond
   ((not url)
    (message "No link under point"))
   ((string-match "^mailto:" url)
    ;; (browse-url-mail url)
    )
   (t
    (news-monitor-w3m-mode-browse-url url)
    ))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; w3m Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode news-monitor-w3m-mode
 w3m-mode "News-Monitor-w3m"
 "Major mode for asserting knowledge about news, w3m mode.
\\{w3m-mode-map}"
 (define-key news-monitor-w3m-mode-map "Kr" 'kmax-not-yet-implemented)
 )

(defun news-monitor-w3m-mode-browse-url (url &optional new-session)
 "Ask news-monitor-w3m to browse URL.
NEW-SESSION specifies whether to create a new news-monitor-w3m session.  URL
defaults to the string looking like a url around the cursor position.
Pop to a window or a frame up according to `w3m-pop-up-windows' and
`w3m-pop-up-frames'."
 (interactive (progn
	       (require 'browse-url)
	       (browse-url-interactive-arg "Emacs-w3m URL: ")))
 (when (stringp url)
  (setq url (w3m-canonicalize-url url))
  (if new-session
   (w3m-goto-url-new-session url)
   (w3m-goto-url url nil nil nil nil nil nil nil t))
  (news-monitor-w3m-mode)))

(defvar news-monitor-default-context "Org::FRDCSA::NewsMonitor")

(global-set-key "\C-cnnfc" 'news-monitor-declare-item-on-top-of-stack-requires-fact-check)
(global-set-key "\C-cnnfa" 'news-monitor-declare-article-requires-action)

;; (defun news-monitor-declare-item-on-top-of-stack-requires-fact-check ()
;;  "Declare item on top of stack requires fact check"
;;  (interactive)
;;  (if (nth 0 freekbs2-stack)
;;   (freekbs2-assert-formula (list "requires-fact-check" (nth 0 freekbs2-stack)) news-monitor-default-context)
;;   (message "No item on stack")))

;; (defun news-monitor-declare-article-requires-action ()
;;  "Declare the fact that the current article requires an action"
;;  (interactive)
;;  (if (nth 0 freekbs2-stack)
;;   (freekbs2-assert-formula (list "requires-action" (nth 0 freekbs2-stack)) news-monitor-default-context)
;;   (message "No item on stack")))

;; (defun news-monitor-save-article ()
;;  ""
;;  (interactive)
;;  )

;; create a news coding system, similar to kids or what not, to mark
;; the news we read and classify it

;; (defun gnus-coding-system)

;; have stuff to relate entries that are being browsed using gnus rss
;; reader to the stored versions of news-monitor.  allow us to assert
;; things about these news items, such as what their topics are, etc.

;; integrate nlu with this stuff, as we should analyze the news
;; articles, etc
