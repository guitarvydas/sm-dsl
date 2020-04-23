(in-package :sm-dsl)

(defparameter *pasm-script* "sm-dsl.pasm")
(defparameter *generated-lisp* "sm-dsl.lisp")

(defun generate (&optional (given-output-filename nil))
  (let ((output-filename (or given-output-filename (asdf:system-relative-pathname :sm-dsl *generated-lisp*))))
    (pasm:pasm-to-file 'random-symbol-from-this-package
		       (asdf:system-relative-pathname :sm-dsl *pasm-script*)
		       output-filename)
    (format nil "generated ~a" *generated-lisp*)))

