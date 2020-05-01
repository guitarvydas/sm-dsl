machineDescriptor = { name initiallyDescriptor statesBag pipeline }
initiallyDescriptor = :bag statement
statesBag = :bag state
state = { name eventsBag }
eventsBag = :bag event
event = { onName statementsBag }
onName = :string

statementsBag = :bag statement
statement = | sendStatement | callStatement
sendStatement = { callkind='send' expression }
callStatement = { callkind='call' expressionMap }
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
