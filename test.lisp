(in-package :sm-dsl)

(defparameter *pp* nil)

(defun transpile-snippet (in-string rule-name)
  (let ((tokens (scanner:scanner in-string)))
    (let ((p (make-instance 'sm-dsl-parser)))
      (initially p tokens)
      (setf *pp* p)
      
      (funcall rule-name p) ;; call top rule

      (let ((result-string (get-output-stream-string (pasm:output-string-stream p))))
	(setf *pp* p)
	result-string))))

(defun test ()
  (let ((p (make-instance 'sm-dsl-parser)))
    (let ((md (make-instance 'machineDescriptor-type))
	  (sb (make-instance 'statementsBag-type))
	  (s  (make-instance 'statement-type))
	  (cs (make-instance 'callStatement-type))
	  (n  (make-instance 'name-type)))

    (setf *pp* p) ;; for inspecting

    ($machineDescriptor__NewScope p)
    (setf (accepted-token p) (scanner::make-token
			      :kind 'symbol
			      :text "abc"
			      :line 5
			      :position 6))
    ($symbol__GetName p)          ;; in=(empty) out=(name("abc"))
    (format *standard-output* "~&top(in)=~s top(out)=~s" (stack-dsl::%ntop (input-name (env p))) (stack-dsl::%ntop (output-name (env p))))
    
    
	(progn
    ($machineDescriptor__SetField_name_from_name p)
        (format *standard-output* "~&top(md-in)=~s top(md-out)=~s" (stack-dsl::%ntop (input-machineDescriptor (env p))) (stack-dsl::%ntop (output-machineDescriptor (env p)))))

	#+nil(progn
    ($machineDescriptor__Output p)
        (format *standard-output* "~&top(md-in)=~s top(md-out)=~s" (stack-dsl::%ntop (input-machineDescriptor (env p))) (stack-dsl::%ntop (output-machineDescriptor (env p)))))
#|
    ($statementsBag__AppendFrom_statement p)
    ($callStatement__CoerceTo_statement p)
|#
    )))

(defun test2 ()
  #+nil(let ((str "{ a {b} c }"))
    (transpile-snippet str 'rawExpr))
  #+nil(let ((str "$"))
    (transpile-snippet str 'dollarExpr))

  (let ((str "a"))
    (transpile-snippet str 'callExpr))
  #+nil(let ((str "a(b)"))
    (transpile-snippet str 'callExpr))
)
