fun signOf value = if String.substring(value,0,1)="~" then "~" else "+"
fun unaryEvaluate "+" value = value 
|unaryEvaluate "~" value = if (signOf value) = "+" then ("~"^value) else String.substring(value,1,((String.size value)-1))
|unaryEvaluate "!" "tt" = "ff"
|unaryEvaluate "!" "ff" = "tt"

fun boolToString true = "tt"
|boolToString false = "ff"

fun evalInt "+" v1 v2 = Int.toString(v1+v2)
|evalInt "-" v1 v2 = Int.toString(v1-v2)
|evalInt "*" v1 v2 = Int.toString(v1*v2)
|evalInt "%" v1 v2 = Int.toString(Int.mod(v1,v2))
|evalInt "/" v1 v2 = Int.toString(Real.round(Real.fromInt(v1)/Real.fromInt(v2)))
|evalInt "<" v1 v2 = boolToString(v1<v2)
|evalInt "<=" v1 v2 = boolToString(v1<=v2)
|evalInt ">" v1 v2 = boolToString(v1>v2)
|evalInt ">=" v1 v2 = boolToString(v1>=v2)
|evalInt "=" v1 v2 = boolToString(v1=v2)
|evalInt "<>" v1 v2 = boolToString(v1<>v2)

fun binaryEvaluate "&&" op1 op2 = if op1="ff" then "ff" else op2
|binaryEvaluate "||" op1 op2 = if op1="tt" then "tt" else op2
|binaryEvaluate IntOP op1 op2 = let
  val SOME v1 = Int.fromString(op1)
  val SOME v2 = Int.fromString(op2)
  val result = (evalInt IntOP v1 v2)
in
  result
end

fun listify s = if String.size(s)=1 then [s] 
else String.substring(s,0,1)::listify(String.substring(s,1,((String.size s)-1)))

exception InvalidInput
fun checkDigit s = if (isInList (String.substring(s,0,1)) digits) 
then if String.size(s)=1 then true else (checkDigit (String.substring(s,1,((String.size s)-1))))
else raise InvalidInput

fun checkInput Type "tt" = if Type="bool" then true else raise TypeMismatch
|checkInput Type "ff" = if Type="bool" then true else raise TypeMismatch
|checkInput Type "" = raise InvalidInput
|checkInput Type s = (if (signOf s) = "~" then (checkDigit (String.substring(s,1,((String.size s)-1))))
else (checkDigit s)) andalso if Type = "int" then true else raise TypeMismatch

fun breakLines s = 
let
  fun breakLines' listOfLines "" = listOfLines
  |breakLines' listOfLines s = 
  let
    fun breakLines'' line "" = (line,"")
    |breakLines'' line s = 
    let
      val size =(String.size s)
      val first = String.substring(s,0,1)
      val s = if size = 1 then "" else (String.substring(s,1,(size-1)))
      val return = if first = "\n" then (line,s) else (breakLines'' (line^first) s) 
    in
      return  
    end
    val (h,s) = (breakLines'' "" s)
  in
    breakLines' (listOfLines@[h]) s
  end
in
  breakLines' [] s
end 

fun getIndex x xl = 
let
  fun getIndex' nil i = NONE
  | getIndex' (h::t) i = if h=x then (SOME i) else getIndex' t (i+1)
in
  (getIndex' xl 0)
end

fun breakStringToChars line "" = (line)
    |breakStringToChars line s = 
    let
      val size =(String.size s)
      val first = String.substring(s,0,1)
      val s = if size = 1 then "" else (String.substring(s,1,(size-1))) 
    in
      (breakStringToChars (line@[first]) s)
    end
