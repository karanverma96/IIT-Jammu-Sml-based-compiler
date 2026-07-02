fun Type ((RES("int",line,chars))::tokens) = (tokens,"int")
|Type ((RES("bool",line,chars))::tokens) = (tokens,"bool")
|Type (lookahead::tokens) = ((errorFn lookahead "SyntaxError"),"")