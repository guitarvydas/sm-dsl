(in-package :sm-dsl)


;; machineDescriptor
(defmethod $machineDescriptor__NewScope ((self sm-dsl-parser))
  (~newscope machineDescriptor))

(defmethod $machineDescriptor__ReplaceFrom_machineDescriptor ((self sm-dsl-parser))
  (~replace-top machineDescriptor machineDescriptor))

(defmethod $machineDescriptor__SetField_pipeline_from_pipeline ((self sm-dsl-parser))
  (~set-field machineDescriptor pipeline pipeline))

(defmethod $machineDescriptor__SetField_initially_from_StatementsBag ((self sm-dsl-parser))
  (~set-field machineDescriptor initially statementsBag))

(defmethod $machineDescriptor__SetField_states_from_StatementsBag ((self sm-dsl-parser))
  (~set-field machineDescriptor states statementsBag))

(defmethod $machineDescriptor__Output ((self sm-dsl-parser))
  (~output machineDescriptor))
  
(defmethod $machineDescriptor_emit ((self sm-dsl-parser))
  (error "niy"))


;; statementsBag
(defmethod $statementsBag__NewScope ((self sm-dsl-parser))
  (~newscope statementsBag))

(defmethod $statementsBag__ReplaceFrom_statement ((self sm-dsl-parser))
  (~replace-top statements statemtent))

(defmethod $statementsBag__AppendFrom_statement ((self sm-dsl-parser))
  (~append statementsBag statement))

(defmethod $statementsBag__Output ((self sm-dsl-parser))
  (~output statementsBag))

;; statesBag
(defmethod $statesBag__NewScope ((self sm-dsl-parser))
  (~newscope statesBag))

(defmethod $statesBag__Output ((self sm-dsl-parser))
  (~output statesBag))

(defmethod $statesBag__ReplaceFrom_statement ((self sm-dsl-parser))
  (~replace-top statesBag statement))

;; state
(defmethod state__NewScope ((self sm-dsl-parser))
  (~newscope state))

(defmethod state__Output ((self sm-dsl-parser))
  (~output state))

;; statement
(defmethod $statement__NewScope ((self sm-dsl-parser))
  (~newscope statement))

(defmethod $statement__Output ((self sm-dsl-parser))
  (~output statement))

(defmethod $statement__SetField_events_from_eventsBag ((self sm-dsl-parser))
  (~set-field statement events eventsBag))

(defmethod $statement__SetField__from_name ((self sm-dsl-parser))
  (~set-field statement event name))

(defmethod $statement__SetField_arg_from_expr ((self sm-dsl-parser))
  (~set-field statement arg expr))

;; eventsBag
(defmethod $eventsBag__NewScope ((self sm-dsl-parser))
  (~newscope eventsBag))

(defmethod $eventsBag__Output ((self sm-dsl-parser))
  (~output eventsBag))

(defmethod $eventsBag__AppendFrom_event ((self sm-dsl-parser))
  (~append eventsBag event))

;; event
(defmethod $event__NewScope ((self sm-dsl-parser))
  (~newscope eventsBag))

(defmethod $event__Output ((self sm-dsl-parser))
  (~output event))

(defmethod $event__SetField_code_from_statementsBag ((self sm-dsl-parser))
  (~set-field event code statementsBag))

;; exprsBag
(defmethod $exprsBag__NewScope ((self sm-dsl-parser))
  (~newscope exprsBag))

(defmethod $exprsBag__Output ((self sm-dsl-parser))
  (~output exprsBag))

(defmethod $exprsBag__AppendFrom_parameter ((self sm-dsl-parser))
  (~append exprsBag parameter))

(defmethod $exprsBag__AppendFrom_expr ((self sm-dsl-parser))
  (~append exprsBag expr))

;; expr
(defmethod $expr__NewScope ((self sm-dsl-parser))
  (~newscope expr))

(defmethod $expr__Output ((self sm-dsl-parser))
  (~output expr))

(defmethod $expr__ReplaceFrom_expr ((self sm-dsl-parser))
  (~replace-top expr expr))

(defmethod $dollarExpr__NewScope ((self sm-dsl-parser))
  (~newscope dollarExpr))

(defmethod $dollarExpr__Output ((self sm-dsl-parser))
  (~output dollarExpr))

;; raw Exprs
(defmethod $rawExpr__NewScope ((self sm-dsl-parser))
  (~newscope rawExpr))

(defmethod $rawExpr__Output ((self sm-dsl-parser))
  (~output rawExpr))

(defmethod $rawExpr__ReplaceFrom_expr ((self sm-dsl-parser))
  (~replace-top rawExpr expr))

(defmethod $rawExpr__AppendField_rawText_from__string ((self sm-dsl-parser))
  (~append rawText string))

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

(defmethod $name__ReplaceFrom_Name ((self sm-dsl-parser))
  (~replace-top name name))
  
(defmethod $symbol__GetName ((self sm-dsl-parser))
  (push (scanner:token-text (pasm:accepted-token self))
	(output-name (env self))))
