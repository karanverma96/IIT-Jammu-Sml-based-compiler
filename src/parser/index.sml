use "parser/integers.sml";
use "parser/boolean.sml";
use "parser/type.sml";
use "parser/variableList.sml";
use "parser/declaration.sml";
use "parser/command.sml";
use "parser/programBlock.sml";


fun Parser tokens = (Program tokens [])
fun compiler inputFile = (Parser (Lexer inputFile))