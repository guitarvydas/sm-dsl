= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= statemachine0
  ~rmSpaces
  {[ ?SYMBOL/machine 
                                $machine__NewScope 
       @machine                  $machine__ReplaceWith_machine
    | * >
  ]}
  @pipeline                    $machine__AddFrom_pipeline
                               $machine__Emit

= machine
                                $machine__NewScope
   SYMBOL/machine
   @machineName                 
                                  $statementsBlock__NewScope
   @optional-initially              $machine__SetField_initially_from_StatementsBlock
                                  $statesBlock__NewScope
   @states                          $machine__SetField_states_from_StateBlock
  SYMBOL/end SYMBOL/machine
                                $machine__Output

= machineName               
                                $name__NewScope
  SYMBOL                           $symbol__GetName $name__ReplaceFrom_Name
                                $name__Output
				
= optional-initially
                                $statementsBlock__NewScope
  [ ?SYMBOL/initially
     SYMBOL/initially
     @statemachine0Statements     $statementsBlock__ReplaceFrom_statement
     SYMBOL/end SYMBOL/initially
  | *
  ]
                                $statementsBlock__Output

= states
                                $statesBlock__NewScope
    {[ ?SYMBOL/state 
       @state                     $statesBlock__AddFrom_state
     | * >
    ]}
                                $statesBlock__Output
   
= state
  SYMBOL/state
                                $state__NewScope
    @stateName                    $state__SetField_name_from_name
    '_'
                                  $eventsBlock__NewScope
      @events                        $state__SetField_events_from_eventsBlock
                                  $eventsBlock__PopScope
                                $state__Output
  
= stateName
                                $name__NewScope
    SYMBOL 
                                  $symbol__GetName $name__ReplaceWith_name
                                $name__Output

= eventName
                                $name__NewScope
    SYMBOL/in  %% in v0 state machines, all input events are called 'in' (hard-wired name)
                                  $symbol__GetName $name__ReplaceWith_name
                                $name__Output

= events
                               $eventsBlock__NewScope
  {[ ?SYMBOL/on 
    SYMBOL/on
                                   $event__NewScope
    @eventName                       $event__SetField_name_from_name
    '_'
                                     $statementsBlock__NewScope
    @statemachine0Statements           $event__SetField_Code_from_statementsBlock
                                     $statementsBlock__EndScope
				     $eventsBlock__AddFrom_event
                                   $event__EndScope
   | * >
  ]}
                                $eventsBlock__Output


= statemachine0Statements
                                $statementsBlock__NewScope
  {[ ?SYMBOL/send 
     @statemachine0SendStatement            $statementsBlock__AddFrom_statement
   | ?SYMBOL/end >
   | ?SYMBOL @statemachine0CallStatement    $statementsBlock__AddFrom_statement
   | * >
  ]}
                                $statementsBlock__Output

= statemachine0SendStatement
  SYMBOL/send
                                $statement__NewScope
  @statemachine0Expr               $statement__SetField_arg_from_expr
                                $statement__Output

= optionalParameters
                                $exprsBlock__NewScope
  [ ?'('
    '('
    @parameters                   $exprsBlock__AddFrom_parameter
    ')'
  | *
  ]
                                $exprsBlock__Output

= parameters
                                $exprsBlock__NewScope
  {[ ?'$'   '$' 
        @statemachine0expr        $exprsBlock__AddFrom_expr
   | ?')' >
   | ?SYMBOL                    
     @statemachine0expr           $exprsBlock__AddFrom_expr
  ]}
                                $exprsBlock__Output

= statemachine0CallStatement
                                $statement__NewScope
  SYMBOL                          $symbol__GetName $statement__SetField_name_fromName
  @optionalParameters             $statement__SetField_argsfrom_exprsBlock
                                $statement__Output

= statemachine0expr
                                $expr__NewScope
  [ ?'$' @statemachine0DollarExpr $expr_ReplaceFrom_expr
  | ?'{' @statemachine0RawExpr    $expr_ReplaceFrom_expr
  | &callableSymbol @callExpr     $expr_ReplaceFrom_expr
  | *
  ]
                                $expr__Output

= statemachine0DollarExpr
  '$'                         
                               $dollarExpr__NewScope
                               $dollarExpr__Output			       

= statemachine0RawExpr
                               $rawExpr__NewScope
  '{' 
  {[ ?'{' @statemachine0RawExpr   $rawExpr__ReplaceWith_expr
   | ?'}' >
   | * .                          $string__GetText $rawExpr__AppendField_rawText_from_string
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
    SYMBOL                       $symbol__GetName $pipeline__AddFrom_name
    @morePipes                   $pipeline__AddFrom_pipeline
                              $pipeline__Output

= morePipes
                              $pipeline__NewScope
  {[?'|' 
     '|'
     SYMBOL                      $symbol__GetName $pipeline__AddFrom_name
   | * >
  ]}
                              $pipeline__Output


