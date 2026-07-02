use "tokens.sml";
use "errors.sml";
use "symbolTable.sml";
use "TACemitter.sml";
use "codeFetcher.sml";
use "lexicalAnalyser.sml";
use "parser/index.sml";
use "interpreter/index.sml";
fun execute inputFile = let
	val dump = (TACref := "")
	val (tokens,symbolTable) = (compiler inputFile)
	val TAC = !TACref
	val TAClines = breakLines(TAC)
	val eof = List.length(TAClines)
	fun Interpreter lineNum symbolTable = 
	let
		val tokenisedLine = (LexerForInterpreter (breakStringToChars [] (List.nth(TAClines,lineNum))))
		fun processLine (ID(id,l1,c1)::PUN(":=",l2,c2)::tokens) = ((lineNum+1),(processAssign tokenisedLine symbolTable))
		|processLine (RES("if",l1,c1)::tokens) = ((condBranch tokenisedLine symbolTable lineNum TAClines),symbolTable)
		|processLine (RES("goto",l1,c1)::[ID(label,l2,c2)]) = ((uncondBranch tokenisedLine TAClines),symbolTable)
		|processLine (RES("read",l1,c1)::[ID(id,l2,c2)]) = (lineNum+1,(processRead tokenisedLine symbolTable))  
		|processLine (RES("write",l1,c1)::tokens) = let
		val dump = (processWrite tokenisedLine symbolTable)
		in
			(lineNum+1,symbolTable)
		end
		|processLine (ID(label,l1,c1)::[PUN(":",l2,c2)]) = ((lineNum+1),symbolTable)
		|processLine tokenisedLine = (lineNum+1,symbolTable)
		val (nextLine,symbolTable) = (processLine tokenisedLine)
		val return = if nextLine=eof then (nextLine,symbolTable) else Interpreter nextLine symbolTable 
	in
		return
	end
	val dump = (Interpreter 0 symbolTable) 
in
	(print "\nThree Address Code executed successfully!\n")
end
