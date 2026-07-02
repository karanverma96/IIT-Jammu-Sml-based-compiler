fun readList(infile) =
if TextIO.endOfStream(infile) then nil
else TextIO.inputN(infile,1) :: readList(infile);
fun sourceFile file = readList(TextIO.openIn(file));