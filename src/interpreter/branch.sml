fun condBranch tokenisedLine symbolTable lineNum TAClines = 
let
  val ID(id,l1,c1) = List.nth(tokenisedLine,1)
  val ID(label,l2,c2) = List.nth(tokenisedLine,5)
  val v1 = (getVal id symbolTable)
  val SOME labelLine = (getIndex (label^":") TAClines)
  val lineNum = if v1="ff" then labelLine else (lineNum+1)
in
  lineNum
end

fun uncondBranch [RES("goto",l1,c1),ID(label,l2,c2)] TAClines = 
let
  val SOME labelLine = (getIndex (label^":") TAClines)
in
  labelLine
end