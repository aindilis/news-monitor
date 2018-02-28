(require 'mm-url)
(defadvice mm-url-insert (after DE-convert-atom-to-rss () )
 "Converts atom to RSS by calling xsltproc."
 ;; (when (re-search-forward "<rss version=\"2.0\"" 
 ;; 	nil t)
 ;;  (call-process-region (point-min) (point-max) 
 ;;   "/var/lib/myfrdcsa/codebases/minor/news-monitor/strip-stuff-after-rss.pl" 
 ;;   t t nil)
 ;;  (goto-char (point-min))
 ;;  (message "Converting RSS 2.0 to Atom... ")
 ;;  (call-process-region (point-min) (point-max) 
 ;;   "xsltproc" 
 ;;   t t nil 
 ;;   (expand-file-name "~/.myconfig/.emacs.d/rsstoatom.xslt.xml") "-")
 ;;  (goto-char (point-min))
 ;;  (message "Converting RSS 2.0 to Atom... done")
 ;;  (goto-char (point-min))
 ;;  (message "Converting Atom to RSS... ")
 ;;  (call-process-region (point-min) (point-max) 
 ;;   "xsltproc" 
 ;;   t t nil 
 ;;   (expand-file-name "~/.myconfig/.emacs.d/atom2rss.xsl") "-")
 ;;  (goto-char (point-min))
 ;;  (message "Converting Atom to RSS... done")
 ;;  (gnus-write-buffer "/tmp/buffer.txt")
 ;;  )
 (when (re-search-forward "xmlns=\"http://www.w3.org/.*/Atom\"" 
	nil t)
  (goto-char (point-min))
  (message "Converting Atom to RSS... ")
  (call-process-region (point-min) (point-max) 
   "xsltproc" 
   t t nil 
   (expand-file-name "~/.myconfig/.emacs.d/atom2rss.xsl") "-")
  (goto-char (point-min))
  (message "Converting Atom to RSS... done")))

(ad-activate 'mm-url-insert)