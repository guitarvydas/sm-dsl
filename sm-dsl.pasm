= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= statemachine0
  ~rmSpaces
  {[ ?SYMBOL/machine 
       @machine
    | * >
  ]}
  @pipeline                    $machineDescriptor__SetField_pipeline_from_pipeline
                               $machineDescriptor__Emit

% machine << (nothing) >> machineDescriptor
= machine
                                $machineDescriptor__NewScope
   SYMBOL/machine
   @machineName                     $machineDescriptor__SetField_name_from_name
   @optional-initially              $machineDescriptor__SetField_initiallyDescriptor_from_StatementsBag
   @states                          $machine__SetField_states_from_StatesBag
  SYMBOL/end SYMBOL/machine
                                $machineDescriptor__Output
% machineName << (nothing) >> name
= machineName
  SYMBOL                           $symbol__GetName

% << (nothing) >> statementsBag
= optional-initially                                                                    
  [ ?SYMBOL/initially
     SYMBOL/initially
     @statements 
     SYMBOL/end SYMBOL/initially
  | * 
     $statementsBag__NewScope $statementsBag__Output
  ]
                                $statementsBag__Output


% states << (nothing) >> statesBag
= states                        
                                $statesBag__NewScope
    {[ ?SYMBOL/state 
       @state                     $statesBag__AppendFrom_state
     | * >
    ]}
                                $statesBag__Output

% state << (nothing) >> state
= state
  SYMBOL/state
                                $state__NewScope
    @stateName                    $state__SetField_name_from_name
    '_'
    @events                       $state__SetField_events_from_eventsBag
                                $state__Output

% stateName << (nothing) >> name
= stateName
    SYMBOL 
                                  $symbol__GetName

% event << (nothing) >> eventsBag
= events
                               $eventsBag__NewScope
  {[ ?SYMBOL/on 
    SYMBOL/on
                                   $event__NewScope
    @eventName                       $event__SetField_name_from_name
    '_'
    @statements                      $event__SetField_Code_from_statementsBag
				     $eventsBag__AppendFrom_event
                                   $event__EndScope
   | * >
  ]}
                                $eventsBag__Output

% eventName << (nothing) >> name
= eventName
    SYMBOL/in  %% in v0 state machines, all input events are called 'in' (hard-wired name)
                                  $symbol__GetName


% statements << (nothing) >> statementsBag
= statements
                                $statementsBag__NewScope
  {[ ?SYMBOL/send 
     @sendStatement                $sendStatement__CoerceTo_statement $statementsBag__AppendFrom_statement
   | ?SYMBOL/end >
   | ?SYMBOL @callStatement        $callStatement__CoerceTo_statement $statementsBag__AppendFrom_statement
   | * >
  ]}
                                $statementsBag__Output

% sendStatement << (nothing) >> statement
= sendStatement
  SYMBOL/send
                                $sendStatement__NewScope
  @statemachine0Expr               $statement__SetField_arg_from_expr
                                $sendStatement__Output

% callStatement << (nothing) >> statement
= callStatement
                                $callStatement__NewScope
  SYMBOL                          $symbol__GetName $statement__SetField_name_from_name
  @optionalParameters             $statement__SetField_argsfrom_expressionMap
                                $callStatement__Output



% expr << (nothing) >> expr
= expr
  [ ?'$' @dollarExpr              $dollarExpr__PushTo_expression
  | ?'{' @rawExpr                 $rawExpr__PushTo_expression
  | &callableSymbol @callExpr     $callExpr__PushTo_expression
  | *                             $expression__NewScope
  ]
                                $expression__Output
				
% dollarExpr >> dollarExpr
= dollarExpr
  '$'                         
                               $dollarExpr__NewScope
                               $dollarExpr__Output			       

% >> rawExpr
= rawExpr
                               $rawExpr__NewScope
  '{'                           $rawExpr__StringAppend_rawText
  {[ ?'{' @rawExpr               $rawExpr__Join
   | ?'}' >
   | * .                         $rawExpr__StringAppend_rawText
  ]}
  '}'                           $rawExpr__StringAppend_rawText
                               $rawExpr__Output

% callExpr >> callExpr
= callExpr
                              $callExpr__NewScope
  SYMBOL
                                $symbol__GetName
!(input-name output-name)				
                                $callExpr__SetField_name_from_name
!(input-name output-name)				
  @optionalParameters
                                $callExpr__SetField_expressionMap_from_expressionMap
			      $callExpr__Output

% callableSymbol parse-time predicate >> Boolean
- callableSymbol
  [ ?SYMBOL/end ^fail
  | ?SYMBOL     ^ok
  | *           ^fail
  ]

% optionalParameters >> expressionMap
= optionalParameters
                                $expressionMap__NewScope
  [ ?'('
    '('
    @parameters
    ')'
  | *
  ]
                                $expressionMap__Output

% parameters <<>> expressionMap
= parameters
  {[ ?'$'   '$' 
        @expr                     $expressionMap__AppendFrom_expression
   | ?')' >
   | ?SYMBOL                    
     @expr                        $expressionMap__AppendFrom_expression
  ]}

% pipeline >> pipeline
= pipeline
                              $pipeline__NewScope
    SYMBOL                       $symbol__GetName $pipeline__AppendFrom_name
    @morePipes                   $pipeline__AppendFrom_pipeline
                              $pipeline__Output

% morePipes <<>> pipeline
= morePipes
  {[?'|' 
     '|'
     SYMBOL                      $symbol__GetName $pipeline__AppendFrom_name
   | * >
  ]}

% symbol__GetName >> name



= smtester
  ~rmSpaces
   @callExpr
   @callExpr



= runHook
!(input-machineDescriptor output-machineDescriptor input-name output-name input-dollarExpr output-dollarExpr input-rawExpr output-rawExpr input-callExpr output-callExpr input-expr output-expr)


