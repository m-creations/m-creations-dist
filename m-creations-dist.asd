;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2015 by m-creations gmbh
;;;
;;; See LICENCE for details.

(asdf:defsystem #:m-creations-dist
  :description "Describe m-creations-dist here"
  :author "Kambiz Darabi <darabi@m-creations.net>"
  :license "Apache v2"
  :serial t
  :depends-on (:shirakumo-dist)
  :components ((:file "package")
               (:file "m-creations-dist")))

