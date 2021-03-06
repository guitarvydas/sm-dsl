(in-package "SM-DSL")

(defmethod rmSpaces ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "rmSpaces") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead? p :SPACE)))
((pasm:parser-success? (pasm:lookahead? p :COMMENT)))
( t  (pasm:accept p) 
)
)

(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod statemachine0 ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "statemachine0") (pasm::p-into-trace p)
(pasm::pasm-filter-stream p #'rmSpaces)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "machine"))(pasm:call-rule p #'machine)
)
( t (return)
)
)

)

(pasm:call-rule p #'pipeline)
(pasm:call-external p #'$machineDescriptor__SetField_pipeline_from_pipeline)
(pasm:call-external p #'$machineDescriptor__Emit)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod machine ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "machine") (pasm::p-into-trace p)
(pasm:call-external p #'$machineDescriptor__NewScope)
(pasm:input-symbol p "machine")
(pasm:call-rule p #'machineName)
(pasm:call-external p #'$machineDescriptor__SetField_name_from_name)
(pasm:call-rule p #'optional-initially)
(pasm:call-external p #'$machineDescriptor__SetField_initiallyDescriptor_from_StatementsBag)
(pasm:call-rule p #'states)
(pasm:call-external p #'$machine__SetField_states_from_StatesBag)
(pasm:input-symbol p "end")
(pasm:input-symbol p "machine")
(pasm:call-external p #'$machineDescriptor__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod machineName ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "machineName") (pasm::p-into-trace p)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod optional-initially ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "optional-initially") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "initially"))(pasm:input-symbol p "initially")
(pasm:call-rule p #'statements)
(pasm:input-symbol p "end")
(pasm:input-symbol p "initially")
)
( t (pasm:call-external p #'$statementsBag__NewScope)
(pasm:call-external p #'$statementsBag__Output)
)
)

(pasm:call-external p #'$statementsBag__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod states ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "states") (pasm::p-into-trace p)
(pasm:call-external p #'$statesBag__NewScope)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "state"))(pasm:call-rule p #'state)
(pasm:call-external p #'$statesBag__AppendFrom_state)
)
( t (return)
)
)

)

(pasm:call-external p #'$statesBag__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod state ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "state") (pasm::p-into-trace p)
(pasm:input-symbol p "state")
(pasm:call-external p #'$state__NewScope)
(pasm:call-rule p #'stateName)
(pasm:call-external p #'$state__SetField_name_from_name)
(pasm:input-char p #\_)
(pasm:call-rule p #'events)
(pasm:call-external p #'$state__SetField_events_from_eventsBag)
(pasm:call-external p #'$state__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod stateName ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "stateName") (pasm::p-into-trace p)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod events ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "events") (pasm::p-into-trace p)
(pasm:call-external p #'$eventsBag__NewScope)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "on"))(pasm:input-symbol p "on")
(pasm:call-external p #'$event__NewScope)
(pasm:call-rule p #'eventName)
(pasm:call-external p #'$event__SetField_name_from_name)
(pasm:input-char p #\_)
(pasm:call-rule p #'statements)
(pasm:call-external p #'$event__SetField_Code_from_statementsBag)
(pasm:call-external p #'$eventsBag__AppendFrom_event)
(pasm:call-external p #'$event__EndScope)
)
( t (return)
)
)

)

(pasm:call-external p #'$eventsBag__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod eventName ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "eventName") (pasm::p-into-trace p)
(pasm:input-symbol p "in")
(pasm:call-external p #'$symbol__GetName)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod statements ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "statements") (pasm::p-into-trace p)
(pasm:call-external p #'$statementsBag__NewScope)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "send"))(pasm:call-rule p #'sendStatement)
(pasm:call-external p #'$sendStatement__CoerceTo_statement)
(pasm:call-external p #'$statementsBag__AppendFrom_statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(return)
)
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(pasm:call-rule p #'callStatement)
(pasm:call-external p #'$callStatement__CoerceTo_statement)
(pasm:call-external p #'$statementsBag__AppendFrom_statement)
)
( t (return)
)
)

)

(pasm:call-external p #'$statementsBag__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod sendStatement ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "sendStatement") (pasm::p-into-trace p)
(pasm:input-symbol p "send")
(pasm:call-external p #'$sendStatement__NewScope)
(pasm:call-rule p #'statemachine0Expr)
(pasm:call-external p #'$statement__SetField_arg_from_expr)
(pasm:call-external p #'$sendStatement__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod callStatement ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "callStatement") (pasm::p-into-trace p)
(pasm:call-external p #'$callStatement__NewScope)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(pasm:call-external p #'$statement__SetField_name_from_name)
(pasm:call-rule p #'optionalParameters)
(pasm:call-external p #'$statement__SetField_argsfrom_expressionMap)
(pasm:call-external p #'$callStatement__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod expr ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "expr") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\$))(pasm:call-rule p #'dollarExpr)
(pasm:call-external p #'$dollarExpr__MoveTo_expression)
)
((pasm:parser-success? (pasm:lookahead-char? p #\{))(pasm:call-rule p #'rawExpr)
(pasm:call-external p #'$rawExpr__MoveTo_expression)
)
((pasm:parser-success? (pasm:call-predicate p #'callableSymbol))(pasm:call-rule p #'callExpr)
(pasm:call-external p #'$callExpr__MoveTo_expression)
)
( t (pasm:call-external p #'$expr__NewScope)
)
)

(pasm:call-external p #'$expr__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod dollarExpr ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "dollarExpr") (pasm::p-into-trace p)
(pasm:input-char p #\$)
(pasm:call-external p #'$dollarExpr__NewScope)
(pasm:call-external p #'$dollarExpr__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod rawExpr ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "rawExpr") (pasm::p-into-trace p)
(pasm:call-external p #'$rawExpr__NewScope)
(pasm:input-char p #\{)
(pasm:call-external p #'$rawExpr__StringAppend_rawText)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\{))(pasm:call-rule p #'rawExpr)
(pasm:call-external p #'$rawExpr__Join)
)
((pasm:parser-success? (pasm:lookahead-char? p #\}))(return)
)
( t  (pasm:accept p) 
(pasm:call-external p #'$rawExpr__StringAppend_rawText)
)
)

)

(pasm:input-char p #\})
(pasm:call-external p #'$rawExpr__StringAppend_rawText)
(pasm:call-external p #'$rawExpr__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod callExpr ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "callExpr") (pasm::p-into-trace p)
(pasm:call-external p #'$callExpr__NewScope)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(hook-list p 'input-name 'output-name )

(pasm:call-external p #'$callExpr__SetField_name_from_name)
(hook-list p 'input-name 'output-name )

(pasm:call-rule p #'optionalParameters)
(pasm:call-external p #'$callExpr__SetField_expressionMap_from_expressionMap)
(pasm:call-external p #'$callExpr__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod callableSymbol ((p pasm:parser)) ;; predicate
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "callableSymbol") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(setf (current-rule p) prev-rule) (pasm::p-into-trace p)(return-from callableSymbol pasm:+fail+)
)
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(setf (current-rule p) prev-rule) (pasm::p-return-trace p)(return-from callableSymbol pasm:+succeed+)
)
( t (setf (current-rule p) prev-rule) (pasm::p-into-trace p)(return-from callableSymbol pasm:+fail+)
)
)

(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod optionalParameters ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "optionalParameters") (pasm::p-into-trace p)
(pasm:call-external p #'$expressionMap__NewScope)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'parameters)
(pasm:input-char p #\))
)
( t )
)

(pasm:call-external p #'$expressionMap__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod parameters ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "parameters") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\$))(pasm:input-char p #\$)
(pasm:call-rule p #'expression)
(pasm:call-external p #'$expressionMap__AppendFrom_expr)
)
((pasm:parser-success? (pasm:lookahead-char? p #\)))(return)
)
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(pasm:call-rule p #'expression)
(pasm:call-external p #'$expressionMap__AppendFrom_expr)
)
)

)

(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod pipeline ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "pipeline") (pasm::p-into-trace p)
(pasm:call-external p #'$pipeline__NewScope)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(pasm:call-external p #'$pipeline__AppendFrom_name)
(pasm:call-rule p #'morePipes)
(pasm:call-external p #'$pipeline__AppendFrom_pipeline)
(pasm:call-external p #'$pipeline__Output)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod morePipes ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "morePipes") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\|))(pasm:input-char p #\|)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$symbol__GetName)
(pasm:call-external p #'$pipeline__AppendFrom_name)
)
( t (return)
)
)

)

(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod smtester ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "smtester") (pasm::p-into-trace p)
(pasm::pasm-filter-stream p #'rmSpaces)
(pasm:call-rule p #'callExpr)
(pasm:call-rule p #'callExpr)
(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod runHook ((p pasm:parser))
  (let ((prev-rule (current-rule p)))     (setf (current-rule p) "runHook") (pasm::p-into-trace p)
(hook-list p 'input-machineDescriptor 'output-machineDescriptor 'input-name 'output-name 'input-dollarExpr 'output-dollarExpr 'input-rawExpr 'output-rawExpr 'input-callExpr 'output-callExpr 'input-expr 'output-expr )

(setf (current-rule p) prev-rule) (pasm::p-return-trace p)))

