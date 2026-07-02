fun BoolExpression tokens symbolTable = let
	val (newTokens,newST,rVal1) = (BoolTerm tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherBoolExpression newTokens newST) 
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal)	
end
and anotherBoolExpression (BoolOP("||",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (BoolTerm tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherBoolExpression newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal,"||")	
end
|anotherBoolExpression tokens symbolTable = (tokens,symbolTable,"","") 

and BoolTerm tokens symbolTable = let 
	val (newTokens,newST,rVal1) = (BoolFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherBoolTerm newTokens newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal)	
end

and anotherBoolTerm (BoolOP("&&",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (BoolFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherBoolTerm newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)  
in
    (newlist,newestST,lVal,"&&")
end
|anotherBoolTerm tokens symbolTable = (tokens,symbolTable,"","")  

and RelOP (BoolOP(id,line,chars)::tokens) symbolTable = (tokens,symbolTable,id)
|RelOP (lookahead::tokens) symbolTable =((errorFn lookahead "SyntaxError"),symbolTable,"")
and Comparison tokens symbolTable = let
    val (newTokens,newST,rVal1) = (IntExpression tokens symbolTable) 
    val (newT,newst,oper) = (RelOP newTokens newST)
    val (newtokens,newsymT,rVal2) = (IntExpression newT newst)
    val lVal = (newVar newsymT)
    val dump = (emit ("\n"^lVal^":= "^rVal1^oper^rVal2))
in
    (newtokens,(insertRecord {lexeme=lVal, Type="bool", value="init"} newsymT),lVal)    
end 
and BoolFactor (BOOL(id,line,chars)::tokens) symbolTable = (tokens,symbolTable,id)
|BoolFactor (INT(id,line,chars)::tokens) symbolTable = Comparison (INT(id,line,chars)::tokens) symbolTable
|BoolFactor (AddOP("+",l1,c1)::tokens) symbolTable = Comparison (AddOP("+",l1,c1)::tokens) symbolTable
|BoolFactor (PUN("~",l1,c1)::tokens) symbolTable = Comparison (PUN("~",l1,c1)::tokens) symbolTable
|BoolFactor (ID(id,line,chars)::tokens) symbolTable =
	if (checkIfPresent id symbolTable) then
		if (isInitialized id symbolTable) then 
			if (getType id symbolTable) = "bool" then (tokens,symbolTable,id)
			else Comparison (ID(id,line,chars)::tokens) symbolTable
		else ((errorFn (ID(id,line,chars)) "UninitializedVariable"),symbolTable,id)
	else ((errorFn (ID(id,line,chars)) "UndeclaredVariable"),symbolTable,id)
|BoolFactor (PUN("(",line,chars)::tokens) symbolTable = let
    val (nList,newST,rVal) = 
        let 
            val (newList,newST,rVal) = (BoolExpression tokens symbolTable)
	        val nList = (match newList (PUN(")",0,0)))
        in
            (nList,newST,rVal)    
        end
        handle SyntaxError =>
        let 
            val dump = (print "\nDon't worry error is resolved...\nContinuing Compilation\n")
        in
            Comparison (PUN("(",line,chars)::tokens) symbolTable 
        end
    in
	(nList,newST,rVal)
end
|BoolFactor (BoolOP("!",line,chars)::tokens) symbolTable = let
    val (newL,newST,rVal) = (BoolFactor tokens symbolTable)
    val lVal = (newVar newST)
    val dump = (emit ("\n"^lVal^":= !"^rVal))
in
    (newL,(insertRecord {lexeme=lVal,value=rVal,Type="bool"} newST),lVal)
end
|BoolFactor (lookahead::tokens) symbolTable = ((errorFn lookahead "SyntaxError"),symbolTable,"")