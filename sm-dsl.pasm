= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= statemachine0
  ~rmSpaces
  {[ ?SYMBOL/machine 
                                $machineDescriptor__NewScope 
       @machine                  $machineDescriptor__ReplaceFrom_machineDescriptor
    | * >
  ]}
  @pipeline                    $machineDescriptor__SetField_pipeline_from_pipeline
                               $machineDescriptor__Emit

= machine
                                $machineDescriptor__NewScope
   SYMBOL/machine
   @machineName                 
                                  $statementsBag__NewScope
   @optional-initially              $machineDescriptor__SetField_initiallyDescriptor_from_StatementsBag
                                  $statesBag__NewScope
   @states                          $machine__SetField_states_from_StatesBag
  SYMBOL/end SYMBOL/machine
                                $machineDescriptor__Output

= machineName               
                                $name__NewScope
  SYMBOL                           $symbol__GetName $name__ReplaceFrom_Name
                                $name__Output
				
= optional-initially
                                $statementsBag__NewScope
  [ ?SYMBOL/initially
     SYMBOL/initially
     @statements                  $statementsBag__ReplaceFrom_statement
     SYMBOL/end SYMBOL/initially
  | *
  ]
                                $statementsBag__Output

= states
                                $statesBag__NewScope
    {[ ?SYMBOL/state 
       @state                     $statesBag__AppendFrom_state
     | * >
    ]}
                                $statesBag__Output
   
= state
  SYMBOL/state
                                $state__NewScope
    @stateName                    $state__SetField_name_from_name
    '_'
                                  $eventsBag__NewScope
      @events                        $state__SetField_events_from_eventsBag
                                  $eventsBag__PopScope
                                $state__Output
  
= stateName
                                $name__NewScope
    SYMBOL 
                                  $symbol__GetName $name__ReplaceFrom_name
                                $name__Output

= eventName
                                $name__NewScope
    SYMBOL/in  %% in v0 state machines, all input events are called 'in' (hard-wired name)
                                  $symbol__GetName $name__Replace_From_name
                                $name__Output

= events
                               $eventsBag__NewScope
  {[ ?SYMBOL/on 
    SYMBOL/on
                                   $event__NewScope
    @eventName                       $event__SetField_name_from_name
    '_'
                                     $statementsBag__NewScope
    @statements                      $event__SetField_Code_from_statementsBag
                                     $statementsBag__EndScope
				     $eventsBag__AppendFrom_event
                                   $event__EndScope
   | * >
  ]}
                                $eventsBag__Output


= statements
                                $statementsBag__NewScope
  {[ ?SYMBOL/send 
     @sendStatement                $statementsBag__AppendFrom_statement
   | ?SYMBOL/end >
   | ?SYMBOL @callStatement        $statementsBag__AppendFrom_statement
   | * >
  ]}
                                $statementsBag__Output

= sendStatement
  SYMBOL/send
                                $statement__NewScope
  @statemachine0Expr               $statement__SetField_arg_from_expr
                                $statement__Output

= optionalParameters
                                $exprsBag__NewScope
  [ ?'('
    '('
    @parameters                   $exprsBag__AppendFrom_parameter
    ')'
  | *
  ]
                                $exprsBag__Output

= parameters
                                $exprsBag__NewScope
  {[ ?'$'   '$' 
        @expr                     $exprsBag__AppendFrom_expr
   | ?')' >
   | ?SYMBOL                    
     @expr                        $exprsBag__AppendFrom_expr
  ]}
                                $exprsBag__Output

= statemachine0CallStatement
                                $statement__NewScope
  SYMBOL                          $symbol__GetName $statement__SetField_name_from_name
  @optionalParameters             $statement__SetField_argsfrom_exprsBag
                                $statement__Output

= expr
                                $expr__NewScope
  [ ?'$' @dollarExpr              $expr_ReplaceFrom_expr
  | ?'{' @rawExpr                 $expr_ReplaceFrom_expr
  | &callableSymbol @callExpr     $expr_ReplaceFrom_expr
  | *
  ]
                                $expr__Output

= dollarExpr
  '$'                         
                               $dollarExpr__NewScope
                               $dollarExpr__Output			       

= rawExpr
                               $rawExpr__NewScope
  '{' 
  {[ ?'{' @rawExpr               $rawExpr__ReplaceFrom_expr
   | ?'}' >
   | * .                         $string__GetText $rawExpr__AppendField_rawText_from_string
  ]}
  '}'
                               $rawExpr__Output

- callableSymbol
  [ ?SYMBOL/end ^fail
  | ?SYMBOL     ^ok
  | *           ^fail
  ]

= pipeline
                              $pipeline__NewScope
    SYMBOL                       $symbol__GetName $pipeline__AppendFrom_name
    @morePipes                   $pipeline__AppendFrom_pipeline
                              $pipeline__Output

= morePipes
                              $pipeline__NewScope
  {[?'|' 
     '|'
     SYMBOL                      $symbol__GetName $pipeline__AppendFrom_name
   | * >
  ]}
                              $pipeline__Output


