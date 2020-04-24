machineDescriptor = { name initiallyDescriptor statesBlock pipeline }
initiallyDescriptor = :bag statement
statesBlock = :bag state
state = { name eventsBlock }
eventsBlock = :bag event
event = { onName statementsBlock }
onName = :string

statementsBlock = :bag statement
statement = | sendStatement | callStatement
sendStatement = { callkind='send' expr }
callStatement = { callkind='call' exprmap }
exprMap = :map expr
expr = | rawExpr | dollarExpr | callExpr
dollarExpr = { exprkind='dollar' name }
callExpr = { exprkind='function' exprMap }
rawExpr = { exprkind='raw' rawText }
rawText = :string
name = :string

pipeline = :map name

callkind = 'send' | 'call'
exprkind = 'dollar' | 'function' | 'raw'
