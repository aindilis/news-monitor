;;; news-monitor-grp.el --- group mode commands for News Monitor

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Group Mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-derived-mode news-monitor-group-mode
;;  gnus-group-mode "News-Monitor-Group"
;;  "Major mode for asserting knowledge about news, Group mode.
;; \\{gnus-summary-mode-map}"
;;  (define-key news-monitor-group-mode-map "\r" 'news-monitor-group-select-group)
;;  )

;; (defun news-monitor-group-select-group (&optional all)
;;  "Select this newsgroup.
;; No article is selected automatically.
;; If the group is opened, just switch the summary buffer.
;; If ALL is non-nil, already read articles become readable.
;; If ALL is a positive number, fetch this number of the latest
;; articles in the group.
;; If ALL is a negative number, fetch this number of the earliest
;; articles in the group."
;;  (interactive "P")
;;  (when (and (eobp) (not (gnus-group-group-name)))
;;   (forward-line -1))
;;  (gnus-group-read-group all t)
;;  (news-monitor-summary-mode))

;; (gnus-define-keys gnus-group-mode-map
;; ;;  "r" news-monitor-group-select-group
;;  )

(provide 'news-monitor-grp)
