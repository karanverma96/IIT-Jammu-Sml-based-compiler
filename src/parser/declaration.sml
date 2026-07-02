(*This function inserts a variable in symboltable and raises error if there are multiple declarations*)
fun DeclarationUtility (ID(id,line,chars)::tokens) symbolTable TYPE = 
	if (checkIfPresent id symbolTable) then
	((errorFn (ID(id,line,chars)) "PreviouslyDeclaredVariable"),symbolTable)
	else DeclarationUtility tokens (insertRecord ({lexeme=id, value="", Type=TYPE}) symbolTable) TYPE
|DeclarationUtility (PUN(",",line1,chars1)::tokens) symbolTable TYPE = DeclarationUtility tokens symbolTable TYPE 
|DeclarationUtility tokens symbolTable TYPE = (tokens,symbolTable)

fun Declaration (RES("var",line,chars)::tokens) symbolTable = let
	val (list1,TYPE) = (Type (match (VariableList tokens) (PUN(":",0,0)))) 
	val list2 = (match list1 (PUN(";",0,0)))
	(*Parsing Completed at this stage*)
	val (dump,newSymTable) = (DeclarationUtility tokens symbolTable TYPE)		
in
	(list2,newSymTable)
end
|Declaration (lookahead::tokens) symbolTable = ((errorFn lookahead "SyntaxError"),symbolTable)


fun DeclarationSeq (RES("var",line,chars)::tokens) symbolTable = let 
	val (newList,newSymTable) = (Declaration (RES("var",line,chars)::tokens) symbolTable)
in
	DeclarationSeq newList newSymTable	
end
| DeclarationSeq tokens symbolTable = (tokens,symbolTable)