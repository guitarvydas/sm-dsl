(in-package :state-dsl)

(defun transpile (infile-name outfile-name)
  ;; transpile a state description in infile
  ;; to an output file of .lisp
(format *standard-output* "~&in state~%")  
(format *standard-output* "~&a~%")  
  (let ((in-string (alexandria:read-file-into-string infile-name)))
(format *standard-output* "~&b~%")  
    (let ((tokens (scanner:scanner in-string)))
(format *standard-output* "~&c~%")  
      (let ((p (make-instance 'state-dsl-parser)))
(format *standard-output* "~&d~%")  
	(initially p tokens)
(format *standard-output* "~&e~%")  
	(statemachine0 p) ;; call top rule
(format *standard-output* "~&f~%")  
	(let ((result-string (get-output-stream-string (pasm:output-string-stream p))))
(format *standard-output* "~&g~%")  
	  (with-open-file (f outfile-name :direction :output :if-exists :supersede :if-does-not-exist :create)
			  (write-string result-string f))
	  (format nil "file ~a written" outfile-name))))))

(defun transpile-state (inf outf)
  (format *standard-output* "~&in state~%")
  (transpile inf outf))
