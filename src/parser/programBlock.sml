fun Block tokens symbolTable =let
	val (newTokens,newST) = (DeclarationSeq tokens symbolTable)
in
	(CommandSeq newTokens newST)
end
fun Program (RES("program",line,chars)::ID(id,line1,chars1)::PUN("::",line2,chars2)::tokens) symbolTable = let 
		val returN = (Block tokens symbolTable)
	in
		returN
	end 
|Program (lookahead::tokens) symbolTable = ((errorFn lookahead "SyntaxError"),symbolTable)