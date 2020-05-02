= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= statemachine0
  ~rmSpaces
                              $network__NewScope
  @machines                       $network__SetField_machineBag_from_machineBag
  @pipeline                       $network__SetField_pipeline_from_pipeline
                                $network__Emit
			      $network__EndScope

= machines
                               $machineBag__NewScope
  {[ ?SYMBOL/machine 
       @machine                  $machineBag__AppendFrom_machineDescriptor
    | * >
  ]}
                               $machineBag__Output

- keywrd
  [ ?SYMBOL/machine ^ok
  | ?SYMBOL/end ^ok
  | ?SYMBOL/initially ^ok
  | ?SYMBOL/state ^ok
  | ?SYMBOL/on ^ok
  | ?SYMBOL/send ^ok
  | * ^fail
  ]
  
% machine << (nothing) >> machineDescriptor
= machine
                                $machineDescriptor__NewScope
   SYMBOL/machine
   @machineName                     $machineDescriptor__SetField_name_from_name
   @optionalInitially              $machineDescriptor__SetField_initiallyDescriptor_from_StatementsMap
   @states                          $machineDescriptor__SetField_statesBag_from_StatesBag
  SYMBOL/end SYMBOL/machine
                                $machineDescriptor__Output
% machineName << (nothing) >> name
= machineName
  SYMBOL                           $symbol__GetName

% << (nothing) >> statementsMap
= optionalInitially                                                                    
  [ ?SYMBOL/initially
     SYMBOL/initially
     @statements 
     SYMBOL/end SYMBOL/initially
  | * 
     $statementsMap__NewScope $statementsMap__Output
  ]


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
    ':'
    @events                       $state__SetField_eventsBag_from_eventsBag
                                $state__Output

% stateName << (nothing) >> name
= stateName
    SYMBOL 
                                  $symbol__GetName

% events << (nothing) >> eventsBag
= events
                               $eventsBag__NewScope
  {[ ?SYMBOL/on 
    SYMBOL/on
                                   $event__NewScope
    @eventName                       $event__SetField_name_from_name
    ':'
    @statements                      $event__SetField_statementsMap_from_statementsMap
                                     $event__Output
				     $eventsBag__AppendFrom_event
   | * >
  ]}
                                $eventsBag__Output

% eventName << (nothing) >> name
= eventName
    SYMBOL/in  %% in v0 state machines, all input events are called 'in' (hard-wired name)
                                  $symbol__GetName


% statements << (nothing) >> statementsMap
= statements
                                $statementsMap__NewScope
  {[ ?SYMBOL/send 
     @sendStatement                $sendStatement__CoercePushTo_statement $statementsMap__AppendFrom_statement
   | ?SYMBOL/end >
   | ?SYMBOL @callStatement        $callStatement__CoercePushTo_statement $statementsMap__AppendFrom_statement
   | * >
  ]}
                                $statementsMap__Output

% sendStatement << (nothing) >> statement
= sendStatement
  SYMBOL/send
                                $sendStatement__NewScope
  SYMBOL                          $symbol__GetName
                                  $sendStatement__SetField_name_from_name
  @expr                           $sendStatement__SetField_expression_from_expression
                                $sendStatement__Output

% callStatement << (nothing) >> statement
= callStatement
                                $callStatement__NewScope
  SYMBOL                          $symbol__GetName $callStatement__SetField_name_from_name
  @optionalParameters             $callStatement__SetField_expressionMap_from_expressionMap
                                $callStatement__Output



% expr << (nothing) >> expr
= expr
  [ ?'$' @dollarExpr              $dollarExpr__PushTo_expression
  | ?'{' @rawExpr                 $rawExpr__PushTo_expression
  | &keywrd                       $expression__NewScope
  | * @callExpr                   $callExpr__PushTo_expression
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
    SYMBOL/pipeline
                              $pipeline__NewScope
    SYMBOL                       $symbol__GetName $pipeline__AppendFrom_name
    @morePipes
                              $pipeline__Output
    SYMBOL/end SYMBOL/pipeline
    
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
   @machine




= runHook
!(input-machineDescriptor output-machineDescriptor input-name output-name input-dollarExpr output-dollarExpr input-rawExpr output-rawExpr input-callExpr output-callExpr input-expr output-expr)


