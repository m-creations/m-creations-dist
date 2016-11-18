;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2015 by m-creations gmbh
;;;
;;; See LICENCE for details.

(in-package #:m-creations-dist)

(defmacro relpath (&rest rest)
  `(asdf:system-relative-pathname :m-creations-dist ,@rest))

(defun redist ()
  (setf *dist-name* "m-creations"
        *dist-url* "http://ql.m-creations.net/"
        *releases-dir* (relpath "release" :type :directory)
        *sources-dir* (relpath "source" :type :directory)
        *repositories-file* (relpath (make-pathname :name "repositories" :type "txt")))
  (let ((time (get-internal-real-time)))
    (format T "~&> Redrawing sources ...~%")
    (shirakumo-dist:redraw)
    (format T "~&> Recreating dist ...~%")
    (after-redraw)
    (quickdist:quickdist
     :name *dist-name*
     :version (shirakumo-dist:timestamp)
     :base-url *dist-url*
     :projects-dir *sources-dir*
     :dists-dir *releases-dir*)
    (format T "~&>> DONE! (Took ~fs)~%"
            (/ (- (get-internal-real-time) time) internal-time-units-per-second)))
  (format t "~%Now you can upload the dist with something like this: rsync -av release/ server:/var/www/quicklisp/~%"))

(defun after-redraw ()
  "Copy things around before finalising the distribution"
  (labels ((source-rel (relpath)
           (format nil "~A~A" *sources-dir* relpath))
         (copy-to-env (relpath)
           (let ((basename (subseq relpath (1+ (search "/" relpath :from-end t)))))
             (uiop:copy-file (source-rel relpath) (format nil "~A/hu.dwim.environment/emacs/~A" *sources-dir* basename)))))
    (copy-to-env "hu.dwim.def/emacs/hu.dwim.def.el")
    (copy-to-env "hu.dwim.logger/emacs/hu.dwim.logger.el")
    (copy-to-env "hu.dwim.quasi-quote/emacs/hu.dwim.quasi-quote.el")
    (copy-to-env "hu.dwim.syntax-sugar/emacs/hu.dwim.syntax-sugar.el")
    (uiop:delete-directory-tree (pathname (source-rel "hu.dwim.environment/notes/")) :validate t :if-does-not-exist :ignore)
    (uiop:delete-directory-tree (pathname (source-rel "hu.dwim.environment/etc/")) :validate t :if-does-not-exist :ignore)
    (uiop:delete-directory-tree (pathname (source-rel "hu.dwim.environment/user/")) :validate t :if-does-not-exist :ignore)))
