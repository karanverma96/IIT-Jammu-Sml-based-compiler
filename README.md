[stars-shield]: https://img.shields.io/github/stars/karanverma96/IIT-Jammu-Sml-based-compiler.svg?style=for-the-badge
[stars-url]: https://github.com/karanverma96/IIT-Jammu-Sml-based-compiler/stargazers
[issues-shield]: https://img.shields.io/github/issues/karanverma96/IIT-Jammu-Sml-based-compiler.svg?style=for-the-badge
[issues-url]: https://github.com/karanverma96/IIT-Jammu-Sml-based-compiler/issues
[license-shield]: https://img.shields.io/github/license/karanverma96/IIT-Jammu-Sml-based-compiler.svg?style=for-the-badge
[license-url]: https://github.com/karanverma96/IIT-Jammu-Sml-based-compiler/blob/main/LICENSE

[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<br />
<p align="center">
  <h1 align="center">While-Language Compiler</h1>

  <p align="center">
    A top-down compiler for a small imperative language, written in Standard ML
    <br />
    <a href="https://github.com/karanverma96/IIT-Jammu-Sml-based-compiler/issues">Report Bug</a>
    ·
    <a href="./designDocument.pdf">Design Document</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<br />
<details open="open">
  <summary><b>Table of Contents</b></summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#the-language">The Language</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#project-structure">Project Structure</a></li>
    <li><a href="#origin">Origin</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

A complete compiler for a small imperative ***while-language***, written in Standard ML. It covers the whole pipeline: lexical analysis, top-down parsing, a symbol table, semantic checks, three address code generation, and a TAC interpreter that runs the generated code.

The grammar was designed from scratch. There is no lexer or parser generator used anywhere, every stage is hand written. The full grammar and the design reasoning are in [designDocument.pdf](./designDocument.pdf).


<!-- THE LANGUAGE -->
## The Language

Integer and boolean variables, assignment, `if`, `while`, and console I/O.

```
program factorial ::
var num,fact,i:int;
{
    i:=1;
    fact:=1;
    read num;
    while i<=num do {
        fact:=fact*i;
        i:=i+1;
    }endwh;
    write fact;
}
```

Five sample programs are in `testcases/` : factorial, prime check, palindrome check, decimal to binary, and triangle classification.


<!-- FEATURES -->
## Features

### ***Lexical Analysis***

`lexicalAnalyser.sml` reads the source character by character and produces a token stream. Every token carries its own line and character number along with the lexeme:

```sml
datatype token = RES of string*int*int   (* reserved word *)
               | ID  of string*int*int
               | INT of string*int*int
               | BOOL of string*int*int
               | PUN of string*int*int
               | BoolOP of string*int*int
               | AddOP of string*int*int
               | MulOP of string*int*int
```

Because position travels inside the token, every later stage can report exactly where a fault is without tracking position itself.

### ***Top-Down Parsing***

One module per grammar rule, in `src/parser/` : `programBlock`, `declaration`, `variableList`, `type`, `command`, `boolean`, `integers`. Each module recognises only its own production and hands the rest off, so the file layout matches the grammar.

### ***Semantic Analysis***

`symbolTable.sml` tracks which variables are declared and which have been assigned to. This is what makes undeclared and uninitialized variable use detectable at compile time.

### ***Error Reporting***

Five error conditions, each reported with an exact `(line:char)` position :

1. `SyntaxError` - the token stream does not match any production
2. `PreviouslyDeclaredVariable` - a name is declared twice
3. `UndeclaredVariable` - a name is used before being declared
4. `UninitializedVariable` - a variable is read before anything is assigned to it
5. `TypeMismatch` - an int and a bool are combined in one expression

E.g., `At (line:char) : (7:12) UndeclaredVariable!`

### ***Three Address Code Generation***

Code generation is ***syntax directed***, there is no separate pass. `TACemitter.sml` is just the emit primitive, and the parser modules call it while they recognise productions. `while` and `if` are turned into labels and `goto` at the point they are parsed.

One result of doing it this way : the compiler never builds an AST. The parse tree only exists as the shape of the recursive descent calls.

### ***TAC Interpreter***

`src/interpreter/` executes the generated code. It re-lexes the emitted TAC and runs it line by line with a program counter that the labels and branches move around. So the TAC is a real text artifact, you can print it and check it by hand against what the interpreter does.


<!-- USAGE -->
## Usage

Needs an SML implementation. Developed on SML/NJ.

Modules load each other with `use`, and `use` resolves paths from the working directory of the interpreter, not from the file calling it. So start SML inside `src/`, not at the repository root :

```console
$ cd src
$ sml
```

```sml
- use "execute.sml";
- execute "../testcases/factorial.txt";
```

`read` waits for input on the terminal. Type the value and press enter.

### ***Sample Runs***

| Program | Input | Output |
|---|---|---|
| `factorial.txt` | 5 | 120 |
| `decimalToBinary.txt` | 255 | 11111111 |
| `palindromeCheck.txt` | 121 | 1 |
| `primeCheck.txt` | 9 | 0 |
| `triangleCheck.txt` | 0 0 1 1 2 2 | 0 (collinear) |


<!-- PROJECT STRUCTURE -->
## Project Structure

```
src/
  lexicalAnalyser.sml     character stream to token stream
  tokens.sml              token datatype, carries (lexeme, line, char)
  symbolTable.sml         declaration and initialization tracking
  errors.sml              the five errors, with positions
  TACemitter.sml          emit primitive for three address code
  codeFetcher.sml         source file loading
  execute.sml             entry point
  parser/                 one module per grammar rule
  interpreter/            TAC execution : assignment, branch, read, write
testcases/                five sample programs
designDocument.pdf        grammar and design notes
```


<!-- ORIGIN -->
## Origin

Written in 2020 at IIT Jammu. The commit history here starts in 2026 because the original repository was on a university account that got closed. The code is unchanged from the original.


<!-- LICENSE -->
## License

Distributed under the MIT License. See [LICENSE](./LICENSE) for more information.


<!-- CONTACT -->
## Contact

#### Ask me anything [here](https://github.com/karanverma96/IIT-Jammu-Sml-based-compiler/issues).
