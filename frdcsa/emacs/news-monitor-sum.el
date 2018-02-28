;;; news-monitor-sum.el --- summary mode commands for News Monitor

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Summary Mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-derived-mode news-monitor-summary-mode
;;  gnus-summary-mode "News-Monitor-Summary"
;;  "Major mode for asserting knowledge about news, Summary mode.
;; \\{gnus-summary-mode-map}"
;;  (define-key news-monitor-summary-mode-map "\r" 'news-monitor-summary-scroll-up)
;;  )

;; (defun news-monitor-summary-scroll-up (lines)
;;   "Scroll up (or down) one line current article.
;; Argument LINES specifies lines to be scrolled up (or down if negative).
;; If no article is selected, then the current article will be selected first."
;;   (interactive "p")
;;   (gnus-configure-windows 'article)
;;   (gnus-summary-show-thread)
;;   (when (eq (gnus-summary-select-article nil nil 'pseudo) 'old)
;;     (gnus-eval-in-buffer-window gnus-article-buffer
;;       (cond ((> lines 0)
;; 	     (when (gnus-article-next-page lines)
;; 	       (gnus-message 3 "End of message")))
;; 	    ((< lines 0)
;; 	     (gnus-article-prev-page (- lines))))
;;      ;; (news-monitor-article-mode)
;;      )
;;    )
;;   (gnus-summary-recenter)
;;   (gnus-summary-position-point))

(require 'gnus)
(require 'gnus-sum)
(require 'message)

(add-hook 'gnus-summary-mode-hook
          (lambda ()
            (local-set-key (kbd "M-N s") 'news-monitor-save-article)))

;; (add-hook 'message-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "\en") 'next-line)))
;; (add-hook 'message-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "\e;") 'end-of-line)))

(defun news-monitor-add-quote-to-sayer () 
 "First save the article, and then store and reference it in
sayer for use with NLU and interpretation software"
 (interactive)

 ;; i.e. "Interestingly, IS allows reporting on social media but has
 ;; banned Al Jazeera, Al Arabiya and Orient. That’s because the first
 ;; is the mouthpiece of the Muslim Brotherhood; the second, the
 ;; mouthpiece of Saudi Arabia; and the third, the mouthpiece of
 ;; Syria."

 ;; from this, assert that the articles source, supposedly RT news,
 ;; (get the authors name), asserts that 

 ;; ("has-mouthpiece" "Muslim Brotherhood" "Al Jazeera")
 ;; ("has-mouthpiece" "Saudi Arabia" "Al Arabiya")
 ;; ("has-mouthpiece" "Syria" "Orient")

 ;; furthermore, look up these sources - add them to news monitor


 ;; also, have the ability to look up the provenance of a quote, to
 ;; search quotes, etc


 ;; integrate with NLU, and then use this to start asserting NLU
 ;; context defeasibly about the meaning of the article.  Use Cyc etc
 ;; to break it down.


 (kmax-not-yet-implemented)
 )


(provide 'news-monitor-sum)
