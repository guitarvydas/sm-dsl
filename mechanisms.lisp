(in-package :sm-dsl)

(defun receiveOutput (to-stack from-stack)
  ;; push(top(output-from)) onto input/output-to, e.g. callExpr -> expression
  ;; keep existing type - used for emission
  (let ((val (stack-dsl:%top from-stack)))
    (stack-dsl::%ensure-type (stack-dsl:%element-type to-stack) val)
    (stack-dsl::%push to-stack val)
    (stack-dsl::%pop from-stack)))

;; machineDescriptor
(defmethod $machineDescriptor__NewScope ((self sm-dsl-parser))
  (~newscope machineDescriptor))

(defmethod $machineDescriptor__SetField_pipeline_from_pipeline ((self sm-dsl-parser))
  (~set-field "machineDescriptor" "pipeline" pipeline))

(defmethod $machineDescriptor__SetField_initiallyDescriptor_from_StatementsBag ((self sm-dsl-parser))
  (~set-field "machineDescriptor" "initiallyDescriptor" statementsBag))

(defmethod $machineDescriptor__SetField_states_from_StatementsBag ((self sm-dsl-parser))
  (~set-field "machineDescriptor" "states" statementsBag))

(defmethod $machineDescriptor__SetField_name_from_name ((self sm-dsl-parser))
  (~set-field "machineDescriptor" "name" name))

(defmethod $machineDescriptor__Output ((self sm-dsl-parser))
  (~output machineDescriptor))

(defmethod $machineDescriptor__emit ((self sm-dsl-parser))
  (let ((mdo (stack-dsl::%top (output-machineDescriptor (env self)))))
    (pasm:emit-string self "~&mdo=~s~%" mdo)
    (pasm:emit-string self "~&mdo.name.value=~s~%" (stack-dsl:%value (name mdo)))))


;; statementsMap
(defmethod $statementsMap__NewScope ((self sm-dsl-parser))
  (~newscope statementsMap))

(defmethod $statementsMap__AppendFrom_statement ((self sm-dsl-parser))
  (~append statementsMap statement))

(defmethod $statementsMap__Output ((self sm-dsl-parser))
  (~output statementsMap))

;; statesBag
(defmethod $statesBag__NewScope ((self sm-dsl-parser))
  (~newscope statesBag))

(defmethod $statesBag__Output ((self sm-dsl-parser))
  (~output statesBag))

(defmethod $statesBag__AppendFrom_state ((self sm-dsl-parser))
  (~append statesBag state))

;; state
(defmethod $state__NewScope ((self sm-dsl-parser))
  (~newscope state))

(defmethod $state__Output ((self sm-dsl-parser))
  (~output state))

(defmethod $state__SetField_name_from_name ((self sm-dsl-parser))
  (~set-field "state" "name" name))

(defmethod $state__SetField_eventsBag_from_eventsBag ((self sm-dsl-parser))
  (~set-field "state" "eventsBag" eventsBag))

;; statement
(defmethod $statement__NewScope ((self sm-dsl-parser))
  (~newscope statement))

(defmethod $statement__Output ((self sm-dsl-parser))
  (~output statement))

(defmethod $statement__SetField_events_from_eventsBag ((self sm-dsl-parser))
  (~set-field "statement" "events" eventsBag))

(defmethod $statement__SetField__from_name ((self sm-dsl-parser))
  (~set-field "statement" "event" name))

(defmethod $statement__SetField_arg_from_expr ((self sm-dsl-parser))
  (~set-field "statement" "arg" expr))

;; eventsBag
(defmethod $eventsBag__NewScope ((self sm-dsl-parser))
  (~newscope eventsBag))

(defmethod $eventsBag__Output ((self sm-dsl-parser))
  (~output eventsBag))

(defmethod $eventsBag__AppendFrom_event ((self sm-dsl-parser))
  (~append eventsBag event))

;; event
(defmethod $event__NewScope ((self sm-dsl-parser))
  (~newscope event))

(defmethod $event__Output ((self sm-dsl-parser))
  (~output event))

(defmethod $event__SetField_name_from_name ((self sm-dsl-parser))
  (~set-field "event" "name" name))

(defmethod $event__SetField_statementsMap_from_statementsMap ((self sm-dsl-parser))
  (~set-field "event" "statementsMap" statementsMap))

;; expressionMap
(defmethod $expressionMap__NewScope ((self sm-dsl-parser))
  (~newscope expressionMap))

(defmethod $expressionMap__Output ((self sm-dsl-parser))
  (~output expressionMap))

(defmethod $expressionMap__AppendFrom_expression ((self sm-dsl-parser))
  (~append expressionMap expression))

;; expr
(defmethod $expression__NewScope ((self sm-dsl-parser))
  (~newscope expression))

(defmethod $expression__Output ((self sm-dsl-parser))
  (~output expression))

;; dollar expr
(defmethod $dollarExpr__NewScope ((self sm-dsl-parser))
  (~newscope dollarExpr))

(defmethod $dollarExpr__Output ((self sm-dsl-parser))
  (~output dollarExpr))

#+nil(defmethod $dollarExpr__MoveTo_expression ((self sm-dsl-parser))
  (moveOutput (output-expression (env self))
	      (output-dollarExpr (env self))))

(defmethod $dollarExpr__PushTo_expression ((self sm-dsl-parser))
  (receiveOutput (input-expression (env self))
	      (output-dollarExpr (env self))))

;; call expr
(defmethod $callExpr__NewScope ((self sm-dsl-parser))
  (~newscope callExpr))

(defmethod $callExpr__Output ((self sm-dsl-parser))
  (~output callExpr))

#+nil(defmethod $callExpr__MoveTo_expression ((self sm-dsl-parser))
  (moveOutput (output-expression (env self))
	      (output-callExpr (env self))))

(defmethod $callExpr__PushTo_expression ((self sm-dsl-parser))
  (receiveOutput (input-expression (env self))
	      (output-callExpr (env self))))

(defmethod $callExpr__SetField_name_from_name ((self sm-dsl-parser))
  (~set-field "callExpr" "name" name))

(defmethod $callExpr__SetField_expressionMap_from_expressionMap ((self sm-dsl-parser))
  (~set-field "callExpr" "expressionMap" expressionMap))

;; raw Exprs
(defmethod $rawExpr__NewScope ((self sm-dsl-parser))
  (~newscope rawExpr)
  (setf (rawText (stack-dsl:%top (input-rawExpr (env self)))) ""))

(defmethod $rawExpr__Output ((self sm-dsl-parser))
  (~output rawExpr))

(defmethod $rawExpr__StringAppend_rawText ((self sm-dsl-parser))
  (let ((r (stack-dsl:%top (input-rawExpr (env self)))))
    (let ((text (scanner:token-text (pasm:accepted-token self))))
      (if (eq :character (scanner:token-kind (pasm:accepted-token self)))
	  (setf (rawText r) (concatenate 'string (rawText r) " " (string text) " "))
	  (setf (rawText r) (concatenate 'string (rawText r) " " text " "))))))

(defmethod $rawExpr__Join ((self sm-dsl-parser))
  ;; consume 1 rawExprs from output, >> modify input rawExp
  ;; input-rawExpr.top = string-append (input-rawExpr.top, output-rawExpr.tos) ; pop output-rawExpr
  (let ((r1 (stack-dsl:%top (output-rawExpr (env self)))))
    (stack-dsl:%pop (output-rawExpr (env self)))
    (let ((r2 (stack-dsl:%top (input-rawExpr (env self)))))
      (setf (rawText r2) 
	    (concatenate 'string (rawText r2) (rawText r1))))))

(defmethod $rawExpr__PushTo_expression ((self sm-dsl-parser))
  ;; output-expr.push(output-rawExpr.top) ; output-rawExpr.pop
  (receiveOutput (input-expression (env self))
	      (output-rawExpr (env self))))

;; pipeline
(defmethod $pipeline__NewScope ((self sm-dsl-parser))
  (~newscope pipeline))

(defmethod $pipeline__Output ((self sm-dsl-parser))
  (~output pipeline))

(defmethod $pipeline__AppendFrom_name ((self sm-dsl-parser))
  (~append pipeline name))

(defmethod $pipeline__AppendFrom_pipeline ((self sm-dsl-parser))
  (~append pipeline pipeline))


;; name 
(defmethod $name__NewScope ((self sm-dsl-parser))
  (~newscope name))

(defmethod $symbol__GetName ((self sm-dsl-parser))
  ;; put name onto output stack of "name"
  (let ((str (scanner:token-text (pasm:accepted-token self)))
	(name-object (make-instance (stack-dsl:lisp-sym "name"))))
    (setf (stack-dsl:%value name-object) str)
    (stack-dsl:%push (output-name (env self)) name-object)))

(defmethod $name__Output ((self sm-dsl-parser))
  (~output name))

;; call statement
(defmethod $callStatement__NewScope ((self sm-dsl-parser))
  (~newscope callStatement))
  
(defmethod $callStatement__Output ((self sm-dsl-parser))
  (~output callStatement))

(defmethod $callStatement__CoercePushTo_statement ((self sm-dsl-parser))
  (receiveOutput (output-statement (env self))
	      (output-callStatement (env self))))

(defmethod $callStatement__SetField_name_from_name ((self sm-dsl-parser))
  (~set-field "callStatement" "name" name))

(defmethod $callStatement__SetField_expressionMap_from_expressionMap ((self sm-dsl-parser))
  (~set-field "callStatement" "expressionMap" expressionMap))

;; send statement
(defmethod $sendStatement__NewScope ((self sm-dsl-parser))
  (~newscope sendStatement))
  
(defmethod $sendStatement__Output ((self sm-dsl-parser))
  (~output sendStatement))

(defmethod $sendStatement__CoercePushTo_statement ((self sm-dsl-parser))
  (receiveOutput (output-statement (env self))
		 (output-sendStatement (env self))))

(defmethod $sendStatement__SetField_arg_from_expression ((self sm-dsl-parser))
  (~set-field "sendStatement" "arg" expression))


(defmethod hook-list ((p parser) &rest args)
  (format *standard-output* "~&hook: ")
  (dolist (arg args)
    (let ((ref (stack-ref p (intern (symbol-name arg) "KEYWORD"))))
      (format *standard-output* "~a" (if ref (length (stack-dsl:%stack ref)) "N"))))
  (format *standard-output* "~%"))


(defun stack-ref (self kw)
  (case kw
    (:input-machineDescriptor (input-machineDescriptor (env self)))
    (:output-machineDescriptor (output-machineDescriptor (env self)))
    (:input-name (input-name (env self)))
    (:output-name (output-name (env self)))
    (:input-initiallyDescriptor (input-initiallyDescriptor (env self)))
    (:output-initiallyDescriptor (output-initiallyDescriptor (env self)))
    (:input-statesBag (input-statesBag (env self)))
    (:output-statesBag (output-statesBag (env self)))
    (:input-pipeline (input-pipeline (env self)))
    (:output-pipeline (output-pipeline (env self)))
    (:input-state (input-state (env self)))
    (:output-state (output-state (env self)))
    (:input-eventsBag (input-eventsBag (env self)))
    (:output-eventsBag (output-eventsBag (env self)))
    (:input-event (input-event (env self)))
    (:output-event (output-event (env self)))
    (:input-onName (input-onName (env self)))
    (:output-onName (output-onName (env self)))
    (:input-statementsMap (input-statementsBag (env self)))
    (:output-statementsMap (output-statementsBag (env self)))
    (:input-statement (input-statement (env self)))
    (:output-statement (output-statement (env self)))
    (:input-sendStatement (input-sendStatement (env self)))
    (:output-sendStatement (output-sendStatement (env self)))
    (:input-callStatement (input-callStatement (env self)))
    (:output-callStatement (output-callStatement (env self)))
    (:input-callkind (input-callkind (env self)))
    (:output-callkind (output-callkind (env self)))
    (:input-expr (input-expr (env self)))
    (:output-expr (output-expr (env self)))
    (:input-expressionMap (input-expressionMap (env self)))
    (:output-expressionMap (output-expressionMap (env self)))
    (:input-rawExpr (input-rawExpr (env self)))
    (:output-rawExpr (output-rawExpr (env self)))
    (:input-dollarExpr (input-dollarExpr (env self)))
    (:output-dollarExpr (output-dollarExpr (env self)))
    (:input-callExpr (input-callExpr (env self)))
    (:output-callExpr (output-callExpr (env self)))
    (:input-exprkind (input-exprkind (env self)))
    (:output-exprkind (output-exprkind (env self)))
    (:input-rawText (input-rawText (env self)))
    (:output-rawText (output-rawText (env self)))
    (otherwise nil)
    )
)
