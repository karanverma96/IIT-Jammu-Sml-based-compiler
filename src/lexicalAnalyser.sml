val digits = ["1","2","3","4","5","6","7","8","9","0"]
val alphabet = ["a" ,"b" ,"c" ,"d" ,"e" ,"f" ,"g" ,"h" ,"i" ,"j" ,"k" ,"l" ,"m" ,"n" ,"o" ,"p" ,"q" ,"r" ,"s" ,"t" ,"u" ,"v" ,"w" ,"x" ,"y" ,"z",
"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
val reservedWords = ["goto","program","var","int","bool","read","write","if","then","else","endif","while","do","endwh"]
val booleanValues = ["ff","tt"]
val alphaNum = alphabet@digits

fun isInList peek nil = false
|isInList peek (h::t) = if (peek=h) then true else (isInList peek t)

fun extract (peek::sourceFile) chars Word = if (isInList peek alphaNum) then (extract sourceFile (chars+1) (Word^peek)) else (Word,chars,	(peek::sourceFile)) 
|extract nil chars Word = (Word,chars,nil)

fun lexer ("&"::("&"::sourceFile)) tokens line chars = lexer sourceFile (tokens@[BoolOP("&&",line,chars)]) line (chars+2)
|lexer ("|"::("|"::sourceFile)) tokens line chars = lexer sourceFile (tokens@[BoolOP("||",line,chars)]) line (chars+2)
|lexer ("="::sourceFile) tokens line chars = lexer sourceFile (tokens@[BoolOP("=",line,chars)]) line (chars+1)
|lexer ("<"::(">"::sourceFile)) tokens line chars = lexer sourceFile (tokens@[BoolOP("<>",line,chars)]) line (chars+2)
|lexer ("!"::sourceFile) tokens line chars = lexer sourceFile (tokens@[BoolOP("!",line,chars)]) line (chars+1)
|lexer ("<"::("="::sourceFile)) tokens line chars = lexer sourceFile (tokens@[BoolOP("<=",line,chars)]) line (chars+2)
|lexer ("<"::sourceFile) tokens line chars = lexer sourceFile (tokens@[BoolOP("<",line,chars)]) line (chars+1)
|lexer (">"::("="::sourceFile)) tokens line chars = lexer sourceFile (tokens@[BoolOP(">=",line,chars)]) line (chars+2) 
|lexer (">"::sourceFile) tokens line chars = lexer sourceFile (tokens@[BoolOP(">",line,chars)]) line (chars+1)
|lexer (":"::("="::sourceFile)) tokens line chars = lexer sourceFile (tokens@[PUN(":=",line,chars)]) line (chars+2)
|lexer ("+"::sourceFile) tokens line chars = lexer sourceFile (tokens@[AddOP("+",line,chars)]) line (chars+1)
|lexer ("-"::sourceFile) tokens line chars = lexer sourceFile (tokens@[AddOP("-",line,chars)]) line (chars+1)
|lexer ("*"::sourceFile) tokens line chars = lexer sourceFile (tokens@[MulOP("*",line,chars)]) line (chars+1)
|lexer ("/"::sourceFile) tokens line chars = lexer sourceFile (tokens@[MulOP("/",line,chars)]) line (chars+1)
|lexer ("%"::sourceFile) tokens line chars = lexer sourceFile (tokens@[MulOP("%",line,chars)]) line (chars+1)
|lexer (" "::sourceFile) tokens line chars = lexer sourceFile tokens line (chars+1)
|lexer ("\t"::sourceFile) tokens line chars = lexer sourceFile tokens line (chars+1)
|lexer ("\n"::sourceFile) tokens line chars = lexer sourceFile tokens (line+1) 0
|lexer (":"::(":"::sourceFile)) tokens line chars = lexer sourceFile (tokens@[PUN("::",line,chars)]) line (chars+2)
|lexer (peek::sourceFile) tokens line chars = 
	if (isInList peek digits) then let
		val (num,charsUsed,newSource) = (extract (peek::sourceFile) 0 "")
	in
		lexer newSource (tokens@[INT(num,line,chars)]) line (chars+charsUsed)
	end
	else if (isInList peek alphabet) then let
		val (Word,charsUsed,newSource) = (extract (peek::sourceFile) 0 "")
		val newtokens = tokens@[if (isInList Word reservedWords) then
					RES(Word,line,chars) 
					else if (isInList Word booleanValues) then
					BOOL(Word,line,chars)
					else ID(Word,line,chars)]
	in
		lexer newSource newtokens line (chars+charsUsed)
	end else 
		lexer sourceFile (tokens@[PUN(peek,line,chars)]) line (chars+1)
|lexer nil tokens line chars = tokens

fun Lexer file = (lexer (sourceFile file) nil 1 0) (*Lexical Analyser*)

fun LexerForInterpreter source = (lexer source nil 1 0)