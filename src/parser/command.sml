fun Command (ID(id,line,chars)::PUN(":=",line1,chars1)::tokens) symbolTable = 
	if (checkIfPresent id symbolTable) then
		if (getType id symbolTable)="int" then let
				val (newT,ST,rVal) = IntExpression tokens symbolTable
				val dump = (emit ("\n"^id^":= "^rVal))
			in (newT,(initialize id  ST "init"))
			end
		else let
				val (newT,ST,rVal) = BoolExpression tokens symbolTable
				val dump = (emit ("\n"^id^":= "^rVal))
			in (newT,(initialize id  ST "init"))
			end
	else ((errorFn (ID(id,line,chars)) "UndeclaredVariable"),symbolTable)
| Command (RES("read",line,chars)::ID(id,line1,chars1)::tokens) symbolTable = 
	let
	  val dump = (emit ("\nread "^id))
	in
	  (tokens,(initialize id  symbolTable "init"))
	end
| Command (RES("write",line,chars)::tokens) symbolTable = 
let
	val (newL,newST,rVal) = (IntExpression tokens symbolTable)
	val dump = (emit ("\nwrite "^rVal))
in 
	(newL,newST)
end
| Command (RES("if",line,chars)::tokens) symbolTable = 
let
	val (newList,newST,rVal) = (BoolExpression tokens symbolTable)
	val label1 = (newVar newST)
	val newST = (insertRecord {lexeme=label1, Type="label", value=label1} newST)
	val label2 = (newVar newST) 
	val newST = (insertRecord {lexeme=label2, Type="label", value=label2} newST)
	val dump = (emit ("\nif "^rVal^"=ff goto "^label1))
	val newList = (match newList (RES("then",0,0)))
	val (newList,newST) = (CommandSeq newList newST)
	val dump = (emit ("\ngoto "^label2))
	val newList = (match newList (RES("else",0,0)))
	val dump = (emit ("\n"^label1^":"))
	val (newList,newST) = (CommandSeq newList newST)
	val dump = (emit ("\n"^label2^":"))
	val newList = (match newList (RES("endif",0,0))) 
in
	(newList,newST)
end
| Command (RES("while",line,chars)::tokens) symbolTable =
let
	val label1 = (newVar symbolTable)
	val symbolTable = (insertRecord {lexeme=label1, Type="label", value=label1} symbolTable)
	val label2 = (newVar symbolTable) 
	val symbolTable = (insertRecord {lexeme=label2, Type="label", value=label2} symbolTable)
	val dump = (emit ("\n"^label1^":"))
	val (tokens,symbolTable,rVal) = (BoolExpression tokens symbolTable)
	val dump = (emit ("\nif "^rVal^"=ff goto "^label2))
	val tokens = (match tokens (RES("do",0,0)))
	val (tokens,symbolTable) = (CommandSeq tokens symbolTable)
	val dump = (emit ("\ngoto "^label1))
	val dump = (emit ("\n"^label2^":"))
	val tokens = (match tokens (RES("endwh",0,0)))
in
  (tokens,symbolTable)
end 
| Command (lookahead::tokens) symbolTable = ((errorFn lookahead "SyntaxError"),symbolTable)
	
and CommandSeq (PUN("{",line,chars)::tokens) symbolTable = let
	fun CommandHelper (RES(id,line,chars)::tokens) symbolTable = let
		val (newL,newST) = Command (RES(id,line,chars)::tokens) symbolTable
		val newL1 = (match newL (PUN(";",0,0)))	
	in
		(CommandHelper newL1 newST)
	end	
	|CommandHelper (ID(id,line,chars)::tokens) symbolTable = let
		val (newL,newST) = Command (ID(id,line,chars)::tokens) symbolTable
		val newL1 = (match newL (PUN(";",0,0)))	
	in
		(CommandHelper newL1 newST)
	end
	|CommandHelper tokens symbolTable = (tokens,symbolTable) 
	val (newTokens,newST) = (CommandHelper tokens symbolTable) 
in
	((match newTokens (PUN("}",0,0))),newST)
end