(in-package :state-dsl)

(defparameter *pasm-script* "state-dsl.pasm")
(defparameter *generated-lisp* "state-dsl.lisp")

(defun generate (&optional (given-output-filename nil))
  (let ((output-filename (or given-output-filename (asdf:system-relative-pathname :state-dsl *generated-lisp*))))
    (pasm:pasm-to-file 'random-symbol-from-this-package
		       (asdf:system-relative-pathname :state-dsl *pasm-script*)
		       output-filename)
    (format nil "generated ~a" *generated-lisp*)))

