(require 'gnus)

(let ((dir "/var/lib/myfrdcsa/codebases/minor/news-monitor/frdcsa/emacs"))
 (if (file-exists-p dir)
  (setq load-path
   (cons dir load-path))))

(defun news-monitor-edit-news-monitor-source-of-current-gnus-major-mode ()
 "Edit the News-Monitor emacs source of the current gnus major mode"
 (interactive)
 ;; from http://stackoverflow.com/questions/9559197/edit-current-emacs-major-mode
 (case major-mode
  (gnus-group-mode (ffap "/var/lib/myfrdcsa/codebases/minor/news-monitor/frdcsa/emacs/news-monitor-grp.el"))
  (gnus-summary-mode (ffap "/var/lib/myfrdcsa/codebases/minor/news-monitor/frdcsa/emacs/news-monitor-sum.el"))
  (gnus-article-mode (ffap "/var/lib/myfrdcsa/codebases/minor/news-monitor/frdcsa/emacs/news-monitor-art-w3m.el"))
  (w3m-mode (ffap "/var/lib/myfrdcsa/codebases/minor/news-monitor/frdcsa/emacs/news-monitor-art-w3m.el"))
  (t (error "Don't appear to be in a News-Monitor related mode"))
  ))

(defun news-monitor-reload-articles ()
 "Edit the News-Monitor emacs source of the current gnus major mode"
 (interactive)
 (kmax-not-yet-implemented)
 (pop-to-buffer "*gnus:summary*")
 (kmax-press-key "g")
 (re-search-forward "Misc:nnvirtual")
 (kmax-press-key "RET")
 (end-of-buffer))

(global-set-key "\C-c\C-k\C-n" 'news-monitor-edit-news-monitor-source-of-current-gnus-major-mode)

(require 'news-monitor-grp)
(require 'news-monitor-sum)
(require 'news-monitor-art-w3m)

(provide 'news-monitor)
