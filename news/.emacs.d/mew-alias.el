(require 'mailalias)
(load "/usr/share/emacs/site-lisp/bbdb/lisp/bbdb-com.el")

(defun bbdb-define-all-aliases ()
  "Define mail aliases for some of the records in the database.
Every record which has a `mail-alias' field will have a mail alias
defined for it which is the contents of that field.  If there are
multiple comma-separated words in the `mail-alias' field, then all
of those words will be defined as aliases for that person.

If multiple entries in the database have the same mail alias, then
that alias expands to a comma-separated list of the network addresses
of all of those people."
  (interactive "")
  (let* ((target (cons bbdb-define-all-aliases-field "."))
         (use-abbrev-p (fboundp 'define-mail-abbrev))
         (mail-alias-separator-string (if (boundp 'mail-alias-separator-string)
                                          mail-alias-separator-string
                                        ", "))
         (records (bbdb-search (bbdb-records) nil nil nil target))
         result record aliases match)

    (if use-abbrev-p
        nil
      ;; clear abbrev-table
      (setq mail-aliases nil)
      ;; arrange rebuilt if necessary, this should be done by
      ;; mail-pre-abbrev-expand-hook, but there is none!
      (defadvice sendmail-pre-abbrev-expand-hook
        (before bbdb-rebuilt-all-aliases activate)
        (bbdb-rebuilt-all-aliases)))

    ;; collect an alist of (alias rec1 [rec2 ...])
    (while records
      (setq record (car records))
      (if (bbdb-record-net record)
          (setq aliases (bbdb-split
                         (bbdb-record-getprop record
                                              bbdb-define-all-aliases-field)
                         ","))
        (if (not bbdb-silent-running)
            (bbdb-warn "record %S has no network address, but the aliases: %s"
                        (bbdb-record-name record)
                        (bbdb-record-getprop record
                                             bbdb-define-all-aliases-field)))
        (setq aliases nil))

      (while aliases
        (if (setq match (assoc (car aliases) result))
            (nconc match (cons record nil))
          (setq result (cons (list (car aliases) record) result)))
        (setq aliases (cdr aliases)))
      (setq records (cdr records)))

    ;; iterate over the results and create the aliases
    (while result
      (let* ((aliasstem (caar result))
             (rec (cadar result))
             (group-alias-p (cddar result))
             (nets (if (not group-alias-p) (bbdb-record-net rec)))
             (expansions
              (if group-alias-p
                  (mapcar (lambda (r) (bbdb-dwim-net-address r)) (cdar result))
                (mapcar (lambda (net) (bbdb-dwim-net-address rec net))
                        (if (eq 'all bbdb-define-all-aliases-mode)
                            nets
                          (list (car nets))))))
             (count 1)
             alias expansion)

        (if group-alias-p
            ;; for group aliases we just take all the primary nets and define
            ;; just one expansion!
            (setq expansions (list (mapconcat 'identity expansions
                                              mail-alias-separator-string)))
          ;; this is an alias for a single person so deal with it according to
          ;; the bbdb-define-all-aliases-mode
          (when (or (not (eq 'first bbdb-define-all-aliases-mode))
                    (setq expansions
                          (cons (mapconcat 'identity
                                           (mapcar (lambda (net)
                                                     (bbdb-dwim-net-address
                                                      rec net))
                                                   nets)
                                           mail-alias-separator-string)
                                expansions)
                          count 0))))

        ;; create the aliases for each expansion
        (while expansions
          (cond ((= count 0);; all the nets of a record
                 (setq alias (concat aliasstem "*")))
                ((= count 1);; expansion as usual
                 (setq alias aliasstem))
                (t;; alias# for each net of a record
                 (setq alias (format "%s%s" aliasstem count))))
          (setq count (1+ count))
          (setq expansion (car expansions))

          (if use-abbrev-p
              (define-mail-abbrev alias expansion)
            (define-mail-alias alias expansion))
          (setq alias (or (intern-soft (downcase alias)
                                       (if use-abbrev-p
                                           mail-abbrevs mail-aliases))
                          (error "couldn't find the alias we just defined!")))

          (or (eq (symbol-function alias) 'mail-abbrev-expand-hook)
              (error "mail-aliases contains unexpected hook %s"
                     (symbol-function alias)))
          ;; The abbrev-hook is called with network addresses instead of bbdb
          ;; records to avoid keeping pointers to records, which would lose if
          ;; the database was reverted.  It uses -search-simple to convert
          ;; these to records, which is plenty fast.
          (fset alias (list 'lambda '()
                            (list 'bbdb-mail-abbrev-expand-hook
                                  alias
                                  (list 'quote
                                        (mapcar (lambda (x)
                                                  (car (bbdb-record-net x)))
                                                (cdr (car result)))))))
          (setq expansions (cdr expansions))))
      (setq result (cdr result)))

    (when (not use-abbrev-p)
      (modify-syntax-entry ?* "w" mail-mode-header-syntax-table)
      (sendmail-pre-abbrev-expand-hook))))(defun bbdb-define-all-aliases ()
  "Define mail aliases for some of the records in the database.
Every record which has a `mail-alias' field will have a mail alias
defined for it which is the contents of that field.  If there are
multiple comma-separated words in the `mail-alias' field, then all
of those words will be defined as aliases for that person.

If multiple entries in the database have the same mail alias, then
that alias expands to a comma-separated list of the network addresses
of all of those people."
  (interactive "")
  (let* ((target (cons bbdb-define-all-aliases-field "."))
         (use-abbrev-p (fboundp 'define-mail-abbrev))
         (mail-alias-separator-string (if (boundp 'mail-alias-separator-string)
                                          mail-alias-separator-string
                                        ", "))
         (records (bbdb-search (bbdb-records) nil nil nil target))
         result record aliases match)

    (if use-abbrev-p
        nil
      ;; clear abbrev-table
      (setq mail-aliases nil)
      ;; arrange rebuilt if necessary, this should be done by
      ;; mail-pre-abbrev-expand-hook, but there is none!
      (defadvice sendmail-pre-abbrev-expand-hook
        (before bbdb-rebuilt-all-aliases activate)
        (bbdb-rebuilt-all-aliases)))

    ;; collect an alist of (alias rec1 [rec2 ...])
    (while records
      (setq record (car records))
      (if (bbdb-record-net record)
          (setq aliases (bbdb-split
                         (bbdb-record-getprop record
                                              bbdb-define-all-aliases-field)
                         ","))
        (if (not bbdb-silent-running)
            (bbdb-warn "record %S has no network address, but the aliases: %s"
                        (bbdb-record-name record)
                        (bbdb-record-getprop record
                                             bbdb-define-all-aliases-field)))
        (setq aliases nil))

      (while aliases
        (if (setq match (assoc (car aliases) result))
            (nconc match (cons record nil))
          (setq result (cons (list (car aliases) record) result)))
        (setq aliases (cdr aliases)))
      (setq records (cdr records)))

    ;; iterate over the results and create the aliases
    (while result
      (let* ((aliasstem (caar result))
             (rec (cadar result))
             (group-alias-p (cddar result))
             (nets (if (not group-alias-p) (bbdb-record-net rec)))
             (expansions
              (if group-alias-p
                  (mapcar (lambda (r) (bbdb-dwim-net-address r)) (cdar result))
                (mapcar (lambda (net) (bbdb-dwim-net-address rec net))
                        (if (eq 'all bbdb-define-all-aliases-mode)
                            nets
                          (list (car nets))))))
             (count 1)
             alias expansion)

        (if group-alias-p
            ;; for group aliases we just take all the primary nets and define
            ;; just one expansion!
            (setq expansions (list (mapconcat 'identity expansions
                                              mail-alias-separator-string)))
          ;; this is an alias for a single person so deal with it according to
          ;; the bbdb-define-all-aliases-mode
          (when (or (not (eq 'first bbdb-define-all-aliases-mode))
                    (setq expansions
                          (cons (mapconcat 'identity
                                           (mapcar (lambda (net)
                                                     (bbdb-dwim-net-address
                                                      rec net))
                                                   nets)
                                           mail-alias-separator-string)
                                expansions)
                          count 0))))

        ;; create the aliases for each expansion
        (while expansions
          (cond ((= count 0);; all the nets of a record
                 (setq alias (concat aliasstem "*")))
                ((= count 1);; expansion as usual
                 (setq alias aliasstem))
                (t;; alias# for each net of a record
                 (setq alias (format "%s%s" aliasstem count))))
          (setq count (1+ count))
          (setq expansion (car expansions))

	 (message alias)
	 (define-mail-alias alias expansion)
          (if use-abbrev-p
              (define-mail-abbrev alias expansion)
	   (define-mail-alias alias expansion))
          (setq alias (or (intern-soft (downcase alias)
                                       (if use-abbrev-p
                                           mail-abbrevs mail-aliases))
                          (error "couldn't find the alias we just defined!")))

          (or (eq (symbol-function alias) 'mail-abbrev-expand-hook)
              (error "mail-aliases contains unexpected hook %s"
                     (symbol-function alias)))
          ;; The abbrev-hook is called with network addresses instead of bbdb
          ;; records to avoid keeping pointers to records, which would lose if
          ;; the database was reverted.  It uses -search-simple to convert
          ;; these to records, which is plenty fast.
          (fset alias (list 'lambda '()
                            (list 'bbdb-mail-abbrev-expand-hook
                                  alias
                                  (list 'quote
                                        (mapcar (lambda (x)
                                                  (car (bbdb-record-net x)))
                                                (cdr (car result)))))))
          (setq expansions (cdr expansions))))
      (setq result (cdr result)))

    (when (not use-abbrev-p)
      (modify-syntax-entry ?* "w" mail-mode-header-syntax-table)
      (sendmail-pre-abbrev-expand-hook))))

(defun mew-bbdb-complete-mail-aliases ()
 ""
 (interactive)
 (bbdb-define-all-aliases)
 (insert (cdr (assoc (completing-read "Alias: " mail-aliases) mail-aliases))))
