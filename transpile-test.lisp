(in-package :sm-dsl)

(defun transpile-test (infile-name outfile-name)
  ;; transpile a state description in infile
  ;; to an output file of .lisp
  (let ((cl:*package* (find-package "SM-DSL")))
    (let ((in-string (alexandria:read-file-into-string infile-name)))
      (let ((tokens (scanner:scanner in-string)))
	(let ((p (make-instance 'sm-dsl-parser)))
	  (initially p tokens)
	  (statemachine0 p) ;; call top rule
	  (let ((result-string (get-output-stream-string (pasm:output-string-stream p))))
	    (with-open-file (f outfile-name :direction :output :if-exists :supersede :if-does-not-exist :create)
	      (write-string result-string f))
	    (format nil "file ~a written" outfile-name)))))))
