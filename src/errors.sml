exception SyntaxError
exception PreviouslyDeclaredVariable
exception UndeclaredVariable
exception UninitializedVariable
exception TypeMismatch
fun errorRaise "SyntaxError" = raise SyntaxError
| errorRaise "PreviouslyDeclaredVariable" = raise PreviouslyDeclaredVariable
| errorRaise "UndeclaredVariable" = raise UndeclaredVariable
| errorRaise "UninitializedVariable" = raise UninitializedVariable
| errorRaise "TypeMismatch" = raise TypeMismatch			
fun errorFn token e = let
	val (line,chars) = (extractlinechar token)
	val dump = (print ("At (line:char) : ("^(Int.toString line)^":"^(Int.toString chars)^") "^e^"!\n"))		
	val dump2 = (errorRaise e)	
in
	nil
end
