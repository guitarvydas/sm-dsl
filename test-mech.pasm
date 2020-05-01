= rmSpaces
  [ ?SPACE | ?COMMENT | * . ]

= testMech
  ~rmSpaces
  $machineDescriptor__NewScope

  SYMBOL
  $symbol__GetName

  $machineDescriptor__SetField_name_from_name
  $machineDescriptor__Output
  $machineDescriptor__Emit

= old-machine
  ~rmSpaces
!(input-machineDescriptor output-machineDescriptor input-name output-name)
                                $machineDescriptor__NewScope
   SYMBOL/machine 
   @machineName                     $machineDescriptor__SetField_name_from_name
                                $machineDescriptor__Output
!(input-machineDescriptor output-machineDescriptor input-name output-name)
   $machineDescriptor__Emit




= smtester
  ~rmSpaces
                                $machineDescriptor__NewScope
   SYMBOL/machine 
   @machineName                     $machineDescriptor__SetField_name_from_name

                                $machineDescriptor__Output
   $machineDescriptor__Emit


   @runHook
   @dollarExpr   
   @runHook
   @rawExpr
   @runHook



= runHook
!(input-machineDescriptor output-machineDescriptor input-name output-name input-dollarExpr output-dollarExpr input-rawExpr output-rawExpr input-callExpr output-callExpr input-expr output-expr)


% machineName << (nothing) >> name
= machineName
  SYMBOL                           $symbol__GetName
                                $name__Output

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
