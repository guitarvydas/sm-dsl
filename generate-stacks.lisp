(in-package :sm-dsl)

(defun generate-stacks (root)
  ;; generate stacks.lisp
  (format *standard-output* "~&transpiling stacks.dsl...")
  (format *standard-output* "~&~a~%"
	  (stack-dsl::transpile-stack
	   (format nil "~a~a" root "stacks.dsl")
	   (format nil "~a~a" root "stacks.lisp"))))
  
 
