# bennett

[Code](http://www.jeremybennett.com/publications/download.html) for Jeremy Bennet's Introduction to Compiler Techniques.

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

BUGS             Reported bugs
CORRECTIONS      Known corrections in the text of the book
HELP             Instructions on how to obtain these files by Email
INDEX            Index of files available
Makefile-vam     Make file for the VAM interpreter
Makefile-vas     Make file for the vas assembler
Makefile-vc      Make file for the vc compiler
README           This file
all.shar         Shell archive of all vc, vas and vam files
cg.c             ANSI C code generator for the vc compiler
header           VAM Header for compiled VSL
lib              VAM Library for compiled VSL
main.c           ANSI C driver routines for the vc compiler
opt-1.shar       opt.shar split into 2 smaller pieces for mailers that
opt-2.shar       don't like files over 100K
opt-ex.shar      Examples for the optimiser
opt.shar         Shell archive of optimising code generator
parser.y         YACC parser for the vc compiler
scanner.l        LEX scanner for the vc compiler
vam.c            ANSI C source for the VAM interpreter
vam.doc          Documentation for the VAM interpreter
vas.y            YACC source for the VAS assembler
vc.h             C Header for the vc compiler

These files are available in the UK by Email from the School of Mathematical
Sciences at Bath University. To find out how to obtain them send a message to
jpb=compiler-request@uk.ac.bath.maths with two lines as follows:

   help:
   end:

These files are supplied strictly on an "as is" basis. I am always pleased to
hear about bugs and suggested improvements, but make no promises about fixing
them. Please send any comments/questions you may have electronically to
jpb=compiler-bugs@uk.ac.bath.maths

The optimiser (added spring 1991) was written as a final year dissertation by
Jonathan R Johnson of Carleton University, USA. My thanks for his efforts. The
shell archives (opt.shar and opt-ex.shar) include the modified files. Any
questions about this optimiser should be sent to him direct,
johnsonj@mathcs.carleton.edu

The VAX MACRO code generator (added summer 1991) was written by Ken Schweller
of Buena Vista College, Iowa. My thanks also for his work. The shell archive
(vaxmacro.shar) includes all the modified files. Any questions about this code
generator should be sent to him direct, schweller@bvc.edu

There is also now an experimental anonymous ftp service from
axiom.maths.bath.ac.uk where the files may be found in the directory
pub/comp-tech/jpb-book.

Happy programming,

Jeremy Bennett                          Tel:   (0225) 826891
School of Mathematical Sciences         Telex: 449097 UOBATH G
University of Bath                      Fax:   (0225) 826492 (Group 3)
Bath, BA2 7AY                           Email: jpb@uk.ac.bath.maths
