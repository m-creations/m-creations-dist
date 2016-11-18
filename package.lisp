;;;; package.lisp

(defpackage #:m-creations-dist
  (:use #:cl)
  (:import-from #:shirakumo-dist
                #:*dist-name*
                #:*dist-url*
                #:*releases-dir*
                #:*sources-dir*
                #:*repositories-file*))
