fun match (lookahead::tokens) expectedToken = 
if (extractLexeme lookahead) = (extractLexeme expectedToken) 
then tokens 
else (errorFn lookahead "SyntaxError") 

fun intHelper rVal2 rVal1 oper newSt = let
    val lVal = if rVal2="" then rVal1 else let 
        val l = (newVar newSt)
        val dump = (emit ("\n"^l^":= "^rVal1^oper^rVal2))
    in
        l
    end
    val newestST = if rVal2="" then newSt else (insertRecord {lexeme=lVal,value="init",Type="int"} newSt)
in
  (lVal,newestST)
end
fun IntExpression tokens symbolTable = let
	val (newTokens,newST,rVal1) = (IntTerm tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntExpression newTokens newST) 
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal)	
end
and anotherIntExpression (AddOP("+",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (IntTerm tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntExpression newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal,"+")	
end
|anotherIntExpression (AddOP("-",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (IntTerm tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntExpression newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal,"-")	
end
|anotherIntExpression tokens symbolTable = (tokens,symbolTable,"","") 

and IntTerm tokens symbolTable = let 
	val (newTokens,newST,rVal1) = (IntFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntTerm newTokens newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
	(newlist,newestST,lVal)	
end

and anotherIntTerm (MulOP("*",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (IntFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntTerm newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)  
in
    (newlist,newestST,lVal,"*")
end
|anotherIntTerm (MulOP("/",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (IntFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntTerm newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
    (newlist,newestST,lVal,"/")
end
|anotherIntTerm (MulOP("%",line,chars)::tokens) symbolTable = let
	val (newL,newST,rVal1) = (IntFactor tokens symbolTable)
    val (newlist,newSt,rVal2,oper) = (anotherIntTerm newL newST)
    val (lVal,newestST) = (intHelper rVal2 rVal1 oper newSt)
in
    (newlist,newestST,lVal,"%")
end
|anotherIntTerm tokens symbolTable = (tokens,symbolTable,"","")  

and IntFactor (INT(id,line,chars)::tokens) symbolTable = (tokens,symbolTable,id)
|IntFactor (BOOL(id,line,chars)::tokens) symbolTable = ((errorFn (ID(id,line,chars)) "TypeMismatch"),symbolTable,id)
|IntFactor (ID(id,line,chars)::tokens) symbolTable =
	if (checkIfPresent id symbolTable) then
		if (isInitialized id symbolTable) then 
			if (getType id symbolTable) = "int" then (tokens,symbolTable,id)
			else ((errorFn (ID(id,line,chars)) "TypeMismatch"),symbolTable,id)
		else ((errorFn (ID(id,line,chars)) "UninitializedVariable"),symbolTable,id)
	else ((errorFn (ID(id,line,chars)) "UndeclaredVariable"),symbolTable,id)
|IntFactor (PUN("(",line,chars)::tokens) symbolTable = let
	val (newList,newST,rVal) = (IntExpression tokens symbolTable)
	val nList = (match newList (PUN(")",0,0)))
in
	(nList,newST,rVal)
end
|IntFactor (PUN("~",line,chars)::tokens) symbolTable = let
    val (newL,newST,rVal) = (IntFactor tokens symbolTable)
    val lVal = (newVar newST)
    val dump = (emit ("\n"^lVal^":= ~"^rVal))
in
    (newL,(insertRecord {lexeme=lVal,value=rVal,Type="int"} newST),lVal)
end
|IntFactor (AddOP("+",line,chars)::tokens) symbolTable = let
    val (newL,newST,rVal) = (IntFactor tokens symbolTable)
    val lVal = (newVar newST)
    val dump = (emit ("\n"^lVal^":= +"^rVal))
in
    (newL,(insertRecord {lexeme=lVal,value=rVal,Type="int"} newST),lVal)
end
|IntFactor (lookahead::tokens) symbolTable = ((errorFn lookahead "SyntaxError"),symbolTable,"")