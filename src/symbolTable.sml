type record = {lexeme:string, value:string, Type:string}
type symTable = record list
fun checkIfPresent id (((x as {lexeme=idt,...})::symbolTable):symTable) = if id=idt then true else (checkIfPresent id symbolTable) 
|checkIfPresent id nil = false
fun delete el (h::t) = if el=h then t else h::(delete  el t)
fun getVal id ((x::ST):symTable) = if #lexeme(x)=id then #value(x) else getVal id ST
fun getType id ((x::ST):symTable) = if #lexeme(x)=id then #Type(x) else getType id ST
fun deleteRecord id (ST:symTable) = (delete {Type=(getType id ST), lexeme=id, value=(getVal id ST)} ST)
fun insertRecord Record symbolTable = (Record::symbolTable)
fun isInitialized id ((x::ST):symTable) = if #lexeme(x)=id then #value(x)<>"" else isInitialized id ST 
fun initialize id (ST:symTable) i = (insertRecord {Type=(getType id ST), lexeme=id, value=i} (deleteRecord id ST))

fun newVar ST = let 
    fun appendDigit h ST i = if (checkIfPresent (h^(Int.toString i)) ST) then appendDigit h ST (i+1) 
    else (h^(Int.toString i))
in
    (appendDigit "t" ST 1)
end
