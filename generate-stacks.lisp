(in-package :sm-dsl)

(defun generate-stacks ()
  ;; generate stacks.lisp
  (format *standard-output* "~&transpiling stacks.dsl...")
  (format *standard-output* "~&~a~%"
	  (stack-dsl::transpile-stack "SM-DSL"
				      (path "stacks.dsl")
				      (path "stacks.lisp"))))
  
 
