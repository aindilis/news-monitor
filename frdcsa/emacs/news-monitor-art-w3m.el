;;; news-monitor-art-w3m.el --- art and w3m commands for News Monitor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; w3m Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar news-monitor-default-context "Org::FRDCSA::NewsMonitor")
(defvar news-monitor-save-directory "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/News")
(defvar news-monitor-save-temp-directory (concat news-monitor-save-directory "/temp"))
(defvar news-monitor-skip-processing nil)

;; (setq news-monitor-skip-processing nil)

(global-set-key "\C-cnnfc" 'news-monitor-declare-item-on-top-of-stack-requires-fact-check)
(global-set-key "\C-cnnfa" 'news-monitor-declare-article-requires-action)

(add-hook 'gnus-article-mode-hook
 (lambda ()
  ;; (local-set-key (kbd "M-N b") 'news-monitor-article-mode-browse-url)
  (local-set-key (kbd "M-N c") 'news-monitor-read-with-clear)
  (local-set-key (kbd "M-N C") 'news-monitor-read-region-with-clear)
  (local-set-key (kbd "M-N s s") 'news-monitor-art-w3m-save-article)
  (local-set-key (kbd "M-N s d r") 'news-monitor-declare-desire-to-read-article)
  (local-set-key (kbd "M-N x f") 'news-monitor-get-file-or-directory)
  (local-set-key (kbd "M-N x w") 'news-monitor-forward-article)
  (local-set-key (kbd "M-N x o") 'news-monitor-open-news-storage-directory)

  (local-set-key (kbd "M-N d f") 'news-monitor-declare-item-on-top-of-stack-requires-fact-check)
  (local-set-key (kbd "M-N d a") 'news-monitor-declare-article-requires-action-or-some-real-world-response)
  (local-set-key (kbd "M-N d r") 'news-monitor-declare-article-fully-read)
  (local-set-key (kbd "M-N d R") 'news-monitor-declare-article-read-by-clear)

  (local-set-key (kbd "M-N d c") 'news-monitor-comment-about-article-snippet)
  (local-set-key (kbd "M-N d a") 'news-monitor-comment-about-article)
  ))


(add-hook 'gnus-select-article-hook 'news-monitor-article-mode-hook)

(defun news-monitor-article-mode-hook ()
 ""
 )

(add-hook 'w3m-mode-hook
 (lambda ()
  ;; (local-set-key (kbd "M-N b") 'news-monitor-article-mode-browse-url)
  (local-set-key (kbd "M-N c") 'news-monitor-read-with-clear)
  (local-set-key (kbd "M-N C") 'news-monitor-read-region-with-clear)
  (local-set-key (kbd "M-N s s") 'news-monitor-art-w3m-save-article)
  (local-set-key (kbd "M-N s d r") 'news-monitor-declare-desire-to-read-article)
  (local-set-key (kbd "M-N x f") 'news-monitor-get-file-or-directory)
  (local-set-key (kbd "M-N x w") 'news-monitor-forward-article)

  (local-set-key (kbd "M-N M-N") 'w3m-copy-buffer)
  (local-set-key (kbd "M-N !") 'kmax-not-yet-implemented)

  (local-set-key (kbd "M-N d f") 'news-monitor-declare-item-on-top-of-stack-requires-fact-check)
  (local-set-key (kbd "M-N d a") 'news-monitor-declare-article-requires-action-or-some-real-world-response)
  (local-set-key (kbd "M-N d r") 'news-monitor-declare-article-fully-read)
  (local-set-key (kbd "M-N d R") 'news-monitor-declare-article-read-by-clear)

  (local-set-key (kbd "M-N d c") 'news-monitor-comment-about-article-snippet)
  (local-set-key (kbd "M-N d a") 'news-monitor-comment-about-article)
  ))

(defun news-monitor-article-fn ()
 ""
 (interactive)
 (news-monitor-save-article-skipping-processing)
 (list "news-monitor-article-fn" (news-monitor-get-file-or-directory 'filename t)))

(defun news-monitor-declare-item-on-top-of-stack-requires-fact-check ()
 "Declare item on top of stack requires fact check"
 (interactive)
 (if (nth 0 freekbs2-stack)
  (freekbs2-assert-formula
   (list "requires-fact-check" (news-monitor-article-fn) (nth 0 freekbs2-stack))
   news-monitor-default-context)
  (message "No item on stack")))

(defun news-monitor-declare-article-requires-action-or-some-real-world-response ()
 "Declare the fact that the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "requires-action" (news-monitor-article-fn))
  news-monitor-default-context))

(defun news-monitor-declare-article-fully-read ()
 "Declare the fact that the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "read" "andrewdo" (news-monitor-article-fn))
  news-monitor-default-context))

(defun news-monitor-declare-article-read-by-clear ()
 "Declare the fact that the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "read-by-clear" "andrewdo" (news-monitor-article-fn))
  news-monitor-default-context))

(defun news-monitor-declare-desire-to-read-article ()
 "Declare the desire to read the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "desires" "andrewdo"
   (list "read-document" "andrewdo" (news-monitor-article-fn)))
  news-monitor-default-context))

(defun news-monitor-comment-about-article ()
 "Declare the fact that the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "comment" (news-monitor-article-fn) (read-from-minibuffer "Comment: "))
  news-monitor-default-context))

(defun news-monitor-comment-about-article-snippet ()
 "Declare the fact that the current article requires an action"
 (interactive)
 (if (nth 0 freekbs2-stack)
  (freekbs2-assert-formula
   (list "comment" (news-monitor-article-fn) (nth 0 freekbs2-stack) (read-from-minibuffer "Comment: "))
   news-monitor-default-context)
  (message "No item on stack")))

(defun news-monitor-art-w3m-save-article ()
 ""
 (interactive)
 (news-monitor-save-article))

(defun news-monitor-art-save-article ()
 ""
 (interactive)
 (news-monitor-save-article))

(defun news-monitor-w3m-save-article ()
 ""
 (interactive)
 (news-monitor-save-article))

(defvar news-monitor-save-article-id-filename nil)

(defun news-monitor-save-article ()
 ""
 (interactive)

 (if (kmax-mode-is-derived-from 'gnus-article-mode)
  (progn
   (gnus-summary-goto-article
    (prin1-to-string (elt gnus-current-headers 0)))
   (pop-to-buffer gnus-summary-buffer)
   (setq news-monitor-save-article-id-filename 
    (news-monitor-save-article-from-summary-mode))
   (pop-to-buffer gnus-article-buffer)))
 (if (kmax-mode-is-derived-from 'gnus-summary-mode)
  ;; to reset the rmail to the right location (gnus-output-to-rmail )
  ;; FIXME: have this function check that the rmail file is correct
  (progn
   (setq news-monitor-save-article-id-filename
    (news-monitor-save-article-from-summary-mode))))
 (if (kmax-mode-is-derived-from 'w3m-mode)
  (setq news-monitor-save-article-id-filename
   (news-monitor-save-article-from-w3m-mode)))

 (kmax-window-configuration-to-register-checking ?N)
 (unless news-monitor-skip-processing
  (progn
   (academician-process-filename-with-nlu
    (news-monitor-get-file-or-directory 'text-file t nil nil
     news-monitor-save-article-id-filename))
   (academician-process-filename-with-knext
    (news-monitor-get-file-or-directory 'html-file t nil nil
     news-monitor-save-article-id-filename) nil)))
 (kmax-jump-to-register ?N t)
 news-monitor-save-article-id-filename)

(defun news-monitor-save-article-skipping-processing ()
 ""
 (interactive)
 (let* ((processing news-monitor-skip-processing))
  (setq news-monitor-skip-processing t)
  (news-monitor-save-article)
  (setq news-monitor-skip-processing processing)))

(defvar news-monitor-txt-postfix ".txt")
(defvar news-monitor-html-postfix ".html")
(defvar news-monitor-region-postfix ".region")

(defun news-monitor-save-article-from-summary-mode ()
 ""
 (let* ((id (news-monitor-obtain-id))
	(directory (concat
		   news-monitor-save-directory
		    "/"
		    gnus-newsgroup-name))
	(filename (news-monitor-construct-filename directory id))
	(text-file (concat filename news-monitor-txt-postfix))
	(html-file (concat filename news-monitor-html-postfix))
	)

  (setq news-monitor-temp-article-to-save filename) 
  (message (concat "Trying to save to " filename "..."))

  (news-monitor-summary-save-article-rmail)

  (shell-command
   (concat "mv -f " news-monitor-save-temp-directory "/* /tmp"))
  (shell-command
   (concat "cd "
    (shell-quote-argument news-monitor-save-temp-directory)
    " && ripmime -i " (shell-quote-argument filename)))
  (shell-command
   (concat "cd "
    (shell-quote-argument news-monitor-save-temp-directory)
    " && mv textfile2 " (shell-quote-argument html-file)))
  (shell-command
   (concat "cd "
    (shell-quote-argument news-monitor-save-temp-directory)
    " && w3m -dump " (shell-quote-argument html-file) " > " (shell-quote-argument text-file)))
  (shell-command
   (concat "mv -f " news-monitor-save-temp-directory "/* /tmp"))
  filename))

(defun news-monitor-obtain-id ()
 ""
 (interactive)
 ;; (prin1-to-string (elt gnus-current-headers 0))
 (concat 
  "id_"
  (join "_"
   (mapcar
    (lambda (num) 
     (replace-regexp-in-string "[^a-zA-Z0-9]" "-" (prin1-to-string (elt gnus-current-headers num))))
    (list 4 2 1 0)))
  "_"
  (replace-regexp-in-string "[^a-zA-Z0-9]" "-" (substring-no-properties (elt gnus-current-headers 3)))))

;; (write-region (point) (mark) "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/News/nnvirtual:misc/id_--1092-The-Electronic-Intifada-nnrss--_-Patrick-O--Strickland-_-Hunger-strikes-are-a-thorn-in-Israel-s-side--says-ex-prisoner-_124890_Tue--10-Mar-2015-15-48-51--0000__w3m__http---electronicintifada-net-content-hunger-strikes-are-thorn-israels-side-says")

(defun news-monitor-get-file-or-directory (&optional passed-item dont-open url-arg id-arg filename-arg)
 ""
 (interactive)
 (let* ((choices (list 'id 'directory 'filename 'text-file 'html-file 'w3m-dir 'voy 'nlu))
	(url (if url-arg url-arg w3m-current-url))
	(id (if id-arg id-arg (news-monitor-obtain-id)))
	(directory (concat
		    news-monitor-save-directory
		    "/"
		    gnus-newsgroup-name))
	(filename (if filename-arg filename-arg
		   (if (kmax-mode-is-derived-from 'w3m-mode)
		    (news-monitor-construct-filename directory id url)
		    (news-monitor-construct-filename directory id))))
	(text-file (concat filename news-monitor-txt-postfix))
	(html-file (concat filename news-monitor-html-postfix))
	(w3m-dir (shell-quote-argument (concat news-monitor-save-directory "/w3m")))
	(voy (concat html-file ".voy.gz"))
	(nlu (concat text-file ".nlu.gz"))

	(item (if passed-item
	       passed-item
	       (read (completing-read "Item: "
		      (mapcar (lambda (item) (prin1-to-string item)) choices)))))
	(result
	 (cond
	  ((equal item 'url)
	   (if (kmax-mode-is-derived-from 'w3m-mode)
	    url
	    (error (concat "url not defined for mode " major-mode))))
	  ((equal item 'id) id)
	  ((equal item 'directory) directory)
	  ((equal item 'filename) filename)
	  ((equal item 'text-file) text-file)
	  ((equal item 'html-file) html-file)
	  ((equal item 'w3m-dir) w3m-dir)
	  ((equal item 'voy) voy)
	  ((equal item 'nlu) nlu)
	  ))
	)
  (see result)
  (unless dont-open
   (if (or
	(file-exists-p result)
	(file-directory-p result))
    (ffap result)
    (error (concat "File does not exist: " result))))
  result))

(defun news-monitor-save-article-from-w3m-mode ()
 ""
 ;; (assert the relationship eventually into news-monitor context)
 (setq news-monitor-w3m-count 1)
 (let* ((url w3m-current-url)
	(id (news-monitor-obtain-id))
	(directory (concat
		    news-monitor-save-directory
		    "/"
		    gnus-newsgroup-name))
	(filename (news-monitor-construct-filename directory id url))
	(text-file (concat filename news-monitor-txt-postfix))
	(html-file (concat filename news-monitor-html-postfix))
	(w3m-dir (shell-quote-argument (concat news-monitor-save-directory "/w3m")))
	)
  (save-excursion
   (w3m-view-source)
   (mark-whole-buffer)
   (write-region (point) (mark) html-file)
   (w3m-view-source))
  (shell-command (concat "w3m -dump " (shell-quote-argument html-file) " > " (shell-quote-argument text-file)))
  
  (if (not (file-exists-p w3m-dir))
   (shell-command (concat "mkdir -p " (shell-quote-argument w3m-dir))))
  (shell-command (concat "cd " (shell-quote-argument w3m-dir)
		  " && wget -x " (shell-quote-argument url)))
  filename))

(defun news-monitor-summary-save-in-rmail (&optional file)
 ;; from gnus-summary-save-in-rmail
 "gnus-summary-save-in-rmail"
 (gnus-summary-save-in-rmail news-monitor-temp-article-to-save))

(defun news-monitor-summary-save-article-rmail (&optional arg)
 ;; from gnus-summary-save-article-rmail
 "Append the current article to an rmail file.
If N is a positive number, save the N next articles.
If N is a negative number, save the N previous articles.
If N is nil and any articles have been marked with the process mark,
save those articles instead."
 (interactive "P")
 (require 'gnus-art)
 (let ((gnus-default-article-saver 'news-monitor-summary-save-in-rmail))
  (gnus-summary-save-article arg)))

;; gnus-article-save: Wrong number of arguments: (lambda nil "gnus-summary-save-in-rmail" (interactive "P") (gnus-summary-save-in-rmail news-monitor-temp-article-to-save)), 1

;; (defun news-monitor-read-with-clear ()
;;  ""
;;  (interactive)
;;  ;; eventually add stuff here about reading the article into
;;  ;; academician, using some kind of article index.  maybe borrow the
;;  ;; same article index gnus uses
;;  (if (or (kmax-mode-is-derived-from 'gnus-article-mode)
;;       (kmax-mode-is-derived-from 'w3m-mode))
  
;;   (clear-queue-current-buffer-referent)
;;   (error "not in mode gnus-article-mode")))

(defun news-monitor-read-with-clear ()
 ""
 (interactive)
 ;; eventually add stuff here about reading the article into
 ;; academician, using some kind of article index.  maybe borrow the
 ;; same article index gnus uses
 
 (if (or (kmax-mode-is-derived-from 'gnus-article-mode)
      (kmax-mode-is-derived-from 'w3m-mode))
  (progn
   (kmax-window-configuration-to-register-checking ?M)
   (let ((html-file (news-monitor-get-file-or-directory 'html-file t nil nil
     (news-monitor-save-article))))
    (unless news-monitor-skip-processing
     (clear-queue-filename html-file)))
   (kmax-jump-to-register ?M t))
  (error "not in mode gnus-article-mode")))

(defun news-monitor-forward-article ()
 ""
 (kmax-not-yet-implemented))

(defun news-monitor-read-region-with-clear (start end)
 ""
 (interactive "r")
 ;; eventually add stuff here about reading the article into
 ;; academician, using some kind of article index.  maybe borrow the
 ;; same article index gnus uses
 (if (or (kmax-mode-is-derived-from 'gnus-article-mode)
      (kmax-mode-is-derived-from 'w3m-mode))
  (progn 
   (kmax-window-configuration-to-register-checking ?M)
   (let* ((text-file (news-monitor-get-file-or-directory 'text-file t nil nil
		      (news-monitor-save-article)))
	  (final-file (concat text-file news-monitor-region-postfix
		       
		       ;; "-" (prin1-to-string start)
		       ;; "-" (prin1-to-string end) ".txt"

		       )))
    (write-region start end final-file)
    (unless news-monitor-skip-processing
     (clear-queue-filename final-file))
    )
   (kmax-jump-to-register ?M t))
  (error "not in mode gnus-article-mode")))

;; to reset the rmail to the right location (gnus-output-to-rmail )

;; FIXME: have this function check that the rmail file is correct

; create a news coding system, similar to kids or what not, to mark
;; the news we read and classify it

;; (defun gnus-coding-system)

;; have stuff to relate entries that are being browsed using gnus rss
;; reader to the stored versions of news-monitor.  allow us to assert
;; things about these news items, such as what their topics are, etc.

;; integrate nlu with this stuff, as we should analyze the news
;; articles, etc


;; functions for this mode

;; save the article

;; nlu text analysis on article

;; declare requires fact check

;; declare article read

;; integrate with opencyc / keds etc

;; have type system for articles

;; declare article requires some real world action response

;; situate in multiagent logics

;; forward article to someone else (use audience)


;; what about specific operations for analyzing named entities and
;; linking them and storing the perception of them generated by the
;; article

;; long term storage and look up, specific axiomitizations, filing
;; system for records

;; KBP, KBA

;; (news-monitor-observe-filename-length-limit-for-write-region "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/News/nnvirtual:misc/id_--1092-The-Electronic-Intifada-nnrss--_-Patrick-O--Strickland-_-Hunger-strikes-are-a-thorn-in-Israel-s-side--says-ex-prisoner-_124890_Tue--10-Mar-2015-15-48-51--0000__w3m__http---electronicintifada-net-content-hunger-strikes-are-thorn-israels-side-says-ex-prisoner-14326-utm-source-feedburner-utm-medium-feed-utm-campaign-Feed-3A-electronicIntifada--28Electronic-Intifada-29.html" 322)

(defun news-monitor-observe-filename-length-limit-for-write-region (orig-filename length)
 ""
 (let* ((md5sum (md5 orig-filename))
	(filename
	 (concat 
	  (substring orig-filename 
	   0 (min
	      (length orig-filename)
	      (- length (+ 1 (length md5sum)))))
	  "-" md5sum
	  )))
  filename))
 
(defun news-monitor-declare-desire-to-read-article ()
 "Declare the desire to read the current article requires an action"
 (interactive)
 (freekbs2-assert-formula
  (list "desires" "andrewdo"
   (list "read-document" "andrewdo" (news-monitor-article-fn)))
  news-monitor-default-context))

;; (defun news-monitor-article-mode-browse-url ()
;;  "Browse the URL under point."
;;  (interactive)
;;  (let ((url (get-text-property (point) 'shr-url)))
;;   (cond
;;    ((not url)
;;     (message "No link under point"))
;;    ((string-match "^mailto:" url)
;;     (browse-url-mail url)
;;     )
;;    (t
;;     (news-monitor-w3m-mode-browse-url url)
;;     ))))

;; (news-monitor-construct-filename
;;  "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/News/nnvirtual:misc"
;;  "id_--1092-The-Electronic-Intifada-nnrss--_-Patrick-O--Strickland-_-Hunger-strikes-are-a-thorn-in-Israel-s-side--says-ex-prisoner-_124890_Tue--10-Mar-2015-15-48-51--0000"
;;  "http---electronicintifada-net-content-hunger-strikes-are-thorn-israels-side-says-ex-prisoner-14326-utm-source-feedburner-utm-medium-feed-utm-campaign-Feed-3A-electronicIntifada--28Electronic-Intifada-29.html")

(defun news-monitor-construct-filename (directory id &optional url)
 ""
 (let* ((filename
	(if url
	 (concat directory "/" id "__w3m__" (replace-regexp-in-string "[^a-zA-Z0-9]" "-" url))
	 (concat directory "/" id))))
  (news-monitor-observe-filename-length-limit-for-write-region
   filename
   (- 327
    (+ (max
	(length news-monitor-html-postfix)
	(length news-monitor-txt-postfix)) 
     (length news-monitor-region-postfix))))))

(defun news-monitor-revisit-saved-article (&optional news-monitor-article-fn-id)
 ""
 (interactive)
 (kmax-not-yet-implemented))


(defun news-monitor-open-news-storage-directory ()
 ""
 (interactive)
 (ffap "/var/lib/myfrdcsa/codebases/minor/news-monitor/data/News/nnvirtual:misc"))

(provide 'news-monitor-art-w3m)
