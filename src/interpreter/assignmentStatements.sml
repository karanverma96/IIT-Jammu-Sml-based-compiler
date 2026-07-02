fun processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::ID(id2,l3,c3)::operator::[ID(id3,l5,c5)]) symbolTable =  
let
  val v2 = (getVal id2 symbolTable)
  val v3 = (getVal id3 symbolTable)
  val oper = (extractLexeme operator) 
  val result = (binaryEvaluate oper v2 v3)

in
  (initialize id1 symbolTable result)  
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::operand1::operator::[ID(id3,l5,c5)]) symbolTable =
let
  val v2 = (extractLexeme operand1)
  val v3 = (getVal id3 symbolTable)
  val oper = (extractLexeme operator) 
  val result = (binaryEvaluate oper v2 v3)
in
  (initialize id1 symbolTable result)
end 
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::ID(id2,l3,c3)::operator::[operand2]) symbolTable =
let
  val v2 = (getVal id2 symbolTable)
  val v3 = (extractLexeme operand2)
  val oper = (extractLexeme operator) 
  val result = (binaryEvaluate oper v2 v3)
in
  (initialize id1 symbolTable result)
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::operand1::operator::[operand2]) symbolTable =
let
  val v2 = (extractLexeme operand1)
  val v3 = (extractLexeme operand2)
  val oper = (extractLexeme operator) 
  val result = (binaryEvaluate oper v2 v3)
in
  (initialize id1 symbolTable result)
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::operator::[ID(id2,l3,c3)]) symbolTable = 
let
  val v2 = (getVal id2 symbolTable)
  val oper = (extractLexeme operator)
  val result = (unaryEvaluate oper v2)
in
  (initialize id1 symbolTable result)
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::operator::[operand1]) symbolTable = 
let
  val v2 = (extractLexeme operand1)
  val oper = (extractLexeme operator)
  val result = (unaryEvaluate oper v2)
in
  (initialize id1 symbolTable result)
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::[ID(id2,l3,c3)]) symbolTable = 
let
  val v2 = (getVal id2 symbolTable)
in
  (initialize id1 symbolTable v2)
end
|processAssign (ID(id1,l1,c1)::PUN(":=",l2,c2)::[operand]) symbolTable = 
let
  val v2 = (extractLexeme operand)
in
  (initialize id1 symbolTable v2)
end