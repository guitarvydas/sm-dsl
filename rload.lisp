(in-package :sm-dsl)

(defparameter *root* (asdf:system-relative-pathname :sm-dsl ""))

(defun rload (fname)
  (load (format nil "~a~a" *root* fname)))
