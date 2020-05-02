network = { machineBag pipeline }
machineBag = :bag machineDescriptor
machineDescriptor = { name initiallyDescriptor statesBag }
initiallyDescriptor = :map statement
statesBag = :bag state
state = { name eventsBag }
eventsBag = :bag event
event = { name statementsMap }
onName = :string

statementsMap = :map statement
statement = | sendStatement | callStatement
sendStatement = { callkind='send' name expression }
callStatement = { callkind='call' name expressionMap }
expressionMap = :map expression
expression = | rawExpr | dollarExpr | callExpr
dollarExpr = { exprkind='dollar' name }
callExpr = { exprkind='function' name expressionMap }
rawExpr = { exprkind='raw' rawText }
rawText = :string
name = :string

pipeline = :map name

callkind = 'send' | 'call'
exprkind = 'dollar' | 'function' | 'raw'
