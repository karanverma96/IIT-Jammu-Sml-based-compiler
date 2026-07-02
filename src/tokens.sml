datatype token = RES of string*int*int
| ID of string*int*int
| INT of string*int*int
| BOOL of string*int*int
| PUN of string*int*int
| BoolOP of string*int*int
| AddOP of string*int*int
| MulOP of string*int*int

fun extractLexeme (ID(lexeme,line,chars)) = lexeme
|extractLexeme (RES(lexeme,line,chars)) = lexeme
|extractLexeme (INT(lexeme,line,chars)) = lexeme
|extractLexeme (BOOL(lexeme,line,chars)) = lexeme
|extractLexeme (PUN(lexeme,line,chars)) = lexeme
|extractLexeme (BoolOP(lexeme,line,chars)) = lexeme
|extractLexeme (AddOP(lexeme,line,chars)) = lexeme
|extractLexeme (MulOP(lexeme,line,chars)) = lexeme

fun extractlinechar (ID(lexeme,line,chars)) = (line,chars)
|extractlinechar (RES(lexeme,line,chars)) = (line,chars)
|extractlinechar (INT(lexeme,line,chars)) = (line,chars)
|extractlinechar (BOOL(lexeme,line,chars)) = (line,chars)
|extractlinechar (PUN(lexeme,line,chars)) = (line,chars)
|extractlinechar (BoolOP(lexeme,line,chars)) = (line,chars)
|extractlinechar (AddOP(lexeme,line,chars)) = (line,chars)
|extractlinechar (MulOP(lexeme,line,chars)) = (line,chars)