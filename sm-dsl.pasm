= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= statemachine0
  ~rmSpaces
  {[ ?SYMBOL/machine 
       @machine                  $machineDescriptor__ReplaceFrom_machineDescriptor
    | * >
  ]}
  @pipeline                    $machineDescriptor__SetField_pipeline_from_pipeline
                               $machineDescriptor__Emit

% machine << (nothing) >> machineDescriptor
= machine
                                $machineDescriptor__NewScope
   SYMBOL/machine
   @machineName                 
   @optional-initially              $machineDescriptor__SetField_initiallyDescriptor_from_StatementsBag
   @states                          $machine__SetField_states_from_StatesBag
  SYMBOL/end SYMBOL/machine
                                $machineDescriptor__Output
% machineName << (nothing) >> name
= machineName
                                $name__NewScope
  SYMBOL                           $symbol__GetName $name__ReplaceFrom_Name
                                $name__Output

% << (nothing) >> statementsBag
= optional-initially                                                                    
  [ ?SYMBOL/initially
     SYMBOL/initially
     @statements 
     SYMBOL/end SYMBOL/initially
  | * returnEmptyStatementsBag
  ]
                                $statementsBag__Output

% returnEmptyStatementsBag << (nothing) >> statementsBag
= returnEmptyStatementsBag      
  $statementsBag__NewScope $statementsBag__Output

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
                                $name__NewScope
    SYMBOL 
                                  $symbol__GetName $name__ReplaceFrom_name
                                $name__Output

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
                                $name__NewScope
    SYMBOL/in  %% in v0 state machines, all input events are called 'in' (hard-wired name)
                                  $symbol__GetName $name__Replace_From_name
                                $name__Output


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
  @optionalParameters             $statement__SetField_argsfrom_exprsBag
                                $callStatement__Output



% expr << (nothing) >> expr
= expr
                                $expr__NewScope
  [ ?'$' @dollarExpr              $dollarExpr__CoerceTo_expr $expr_ReplaceFrom_expr
  | ?'{' @rawExpr                 $rawExpr__CoerceTo_expr $expr_ReplaceFrom_expr
  | &callableSymbol @callExpr     $callExpr_CoerceTo_expr $expr_ReplaceFrom_expr
  | *                             $makeEmptyExpr
  ]
                                $expr__Output
% dollarExpr >> dollarExpr
= dollarExpr
  '$'                         
                               $dollarExpr__NewScope
                               $dollarExpr__Output			       

% rawExpr >> rawExpr
= rawExpr
                               $rawExpr__NewScope
  '{' 
  {[ ?'{' @rawExpr               $rawExpr__ReplaceFrom_expr
   | ?'}' >
   | * .                         $string__GetText $rawExpr__AppendField_rawText_from_string
  ]}
  '}'
                               $rawExpr__Output

% callExpr >> callExpr
= callExpr
  SYMBOL
  @optionalParameters

% callableSymbol parse-time predicate >> Boolean
- callableSymbol
  [ ?SYMBOL/end ^fail
  | ?SYMBOL     ^ok
  | *           ^fail
  ]

% optionalParameters << (nothing) >> exprsBag
= optionalParameters
                                $exprsBag__NewScope
  [ ?'('
    '('
    @parameters
    ')'
  | *                             $returnEmptyExprsBag
  ]
                                $exprsBag__Output

% returnEmptyExprsBag << (nothing) >> exprsBag
= returnEmptyExprsBag
  exprsBag__NewScope
  exprsBag__Output

% parameters <<>> exprsBag
= parameters
  {[ ?'$'   '$' 
        @expr                     $exprsBag__AppendFrom_expr
   | ?')' >
   | ?SYMBOL                    
     @expr                        $exprsBag__AppendFrom_expr
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


