fun processWrite (RES("write",l1,c1)::[ID(id,l2,c2)]) symbolTable = 
let
  val v = (getVal id symbolTable)
in 
  (print ("\n"^v))
end
| processWrite (RES("write",l1,c1)::[INT(v1,l2,c2)]) symbolTable = (print ("\n"^v1)) 