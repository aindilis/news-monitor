(load "/var/lib/myfrdcsa/codebases/internal/frdcsa-el/frdcsa-el.el")

(require 'bbdb)
(bbdb-initialize)

(if (file-exists-p "~/.emacs.d/mew.el")
 (load "~/.emacs.d/mew.el")
 )

(if (file-exists-p "~/.emacs.d/.erc-auth.el")
 (load "~/.emacs.d/.erc-auth.el")
 (load "~/.emacs.d/.erc-auth-public.el")
 )

(global-set-key "\C-x\C-g" 'browse-url-firefox)

; (setq debug-on-error t)
; (setq mew-debug t)



;; 15:45:05 <aindilis> I am using gnus to read rss and atom feeds.  It takes a
;;       while to refresh all of these.  Sometimes I accidentally quit out of
;;       gnus.  I am wondering if there is a way to start it without having it
;;       reload all the feeds (as if I had pressed G).
;; 15:49:50 <abbe> aindilis, yes
;; 15:50:09 <aindilis> cool, thanks, what is it?
;; 15:50:28 <abbe> `nnrss-use-local'
;; 15:50:28 <abbe>      If you set `nnrss-use-local' to `t', `nnrss' will read
;;       the feeds
;; 15:50:29 <abbe>      from local files in `nnrss-directory'.  You can use the
;;       command
;; 15:50:29 <abbe>      `nnrss-generate-download-script' to generate a download
;;       script
;; 15:50:29 <abbe>      using `wget'.
;; 15:50:34 <aindilis> thanks :)
;; 15:50:43 <abbe> you're welcome.
;; 15:51:34 <abbe> you can schedule the generated script in cron, or your
;;       favorite process scheduler

;; (setq nnvirtual-always-rescan nil)
;; (setq nnrss-use-local t)