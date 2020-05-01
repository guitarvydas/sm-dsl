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

% machineName << (nothing) >> name
= machineName
  SYMBOL                           $symbol__GetName
                                $name__Output

