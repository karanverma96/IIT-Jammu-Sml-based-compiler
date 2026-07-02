fun processRead (RES("read",l1,c1)::[ID(id,l2,c2)]) symbolTable = 
let
  val dump = (print ("\n"^"Enter "^id^" "))
  val SOME input = (TextIO.inputLine TextIO.stdIn)
  val input = String.substring(input,0,((String.size input)-1))
  val Type = (getType id symbolTable)
  val dump = (checkInput Type input)
in
  (initialize id symbolTable input)
end