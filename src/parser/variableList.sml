fun Variable ((ID(id,line,chars))::tokens) = tokens
|Variable (lookahead::tokens) = (errorFn lookahead "SyntaxError")

fun VariableList (ID(id,line,chars)::tokens) = (vList tokens) 
|VariableList (lookahead::tokens) = (errorFn lookahead "SyntaxError")
|VariableList nil = (errorFn (ID("",0,0)) "SyntaxError")
and
vList (PUN(",",line,chars)::tokens) = (VariableList tokens)
|vList tokens = tokens