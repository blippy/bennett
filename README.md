# bennett

[Code](http://www.jeremybennett.com/publications/download.html) for Jeremy Bennett's Introduction to Compiler Techniques.

## Example Usage

For reference you may like to note that the minimal VSL program is:

```
echo "
FUNC main ()
{
    CONTINUE
}
" > file.vsl
```

Compile and execute it as follows

```
vc file.vsl # creates file file.vas
vas  file.vas # creates file file.vam
vam file.vam # execute
```

If you want a trace:
```
vam -t file.vam > file.trace.output
```

## Notes


The files in this directory are as follows:

```
bugs.txt         Reported bugs
cg.c             ANSI C code generator for the vc compiler
main.c           ANSI C driver routines for the vc compiler
parser.y         YACC parser for the vc compiler
scanner.l        LEX scanner for the vc compiler
vam.c            ANSI C source for the VAM interpreter
vam.doc          Documentation for the VAM interpreter
vas.y            YACC source for the VAS assembler
vc.h             C Header for the vc compiler
```

I have started experiments in writing a VM myself (Mark Carter) at
[myvm](mymv/README.md)

Happy programming,

## License

The license is a little ambiguous. Here's what on Jeremy's download [page](http://www.jeremybennett.com/publications/download.html):


> Feel free to use this code in conjunction with the textbook, or for other uses where you feel it would be helpful. There is no explicit separate license for this software alone, but I should appreciate being cited as the source if you do use it.

> Note.The code is listed in the textbook, which is copyright McGraw-Hill International (UK) Limited. Please act appropriately if you wish to publish extracts from this code.
