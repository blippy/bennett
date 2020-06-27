#!/usr/bin/env perl6
my @args = @*ARGS;

my %labels;
#my @hole-label;
#my @hole-pc;
my @holes;
my $pc = 0; # program counter
my byte @mem;
my $rx = 0; # Rx register in an instruction
my $ry = 0; # Ry register in an instruction
my $offset;

sub len() { @mem.elems }

sub reset() { # clears out undefined optional components of instructions, e.g. in LDA
	$rx = 0;
	$ry = 0;
}


sub big-end($n) {
	my $n1 = $n;
	my byte @barr = [0, 0, 0 ,0];
	for [3,2,1,0] {
		@barr[$_] = $n1;
		$n1 = $n1 +> 8;
	}
	@barr
}

sub pave($opcode) { @mem.append($opcode); }

sub pave-nrxy($opcode) {
	pave $opcode;
	my byte $rxy = $rx +<4 + $ry;
	@mem.append($rxy);
}

sub pave-off() {
	if $offset ~~ Str {
		@holes.push( [$offset, len] );
		@mem.append( 0xD, 0xE, 0xA, 0xD);
	} else {
		@mem.append(big-end $offset);
	}

}

sub pave-noff($opcode) {
	pave $opcode;
	pave-off;
}

sub pave-roff($opcode) {
	pave-nrxy $opcode;
	pave-off;
}

grammar Asm {
	rule TOP 	{ <loioc>* }
	rule loioc 	{ <comment> | <loi> | <blank> } # label or instruction or comment
	token blank	{ \s+ }
	token comment	{ '\\' \N* \n }
	rule label	{ <id>  <colon> { %labels{ $<id> } = len; } }
	rule colon 	{ ':' }
	rule instr 	{ <id> { say "found instruction $<id>"; } }
	token Rx	{ 'R' <digits>  { $rx = $<digits>; } }
	token _Rx_	{ '(' <Rx> ')' }
	token Ry	{ 'R' <digits> { $ry = $<digits>; } }
	token _Ry_	{ '(' <Ry> ')' }
	token id 	{ <[a..zA..Z0..9_]>+ }
	token offset	{ <num> { $offset = "$<num>".Int; } 
	|<id> { $offset = "$<id>"; } }
	token num	{ '-'? <digits> }
	token digits	{ <[0..9]>+ }
	rule RxRy	{ <Rx> ',' <Ry> }

	rule loi 	{ (<halt> | <nop> | <trap> | <add> | <sub> | <mul> 
	| <div> | <sti> | <ldi> | <lda> 
	| <ldr> | <bze> | <bnz> | <bra> | <bal>
	| <db>  | <label>) { reset; } }
	rule halt	{ 'HALT' { pave 0;} }
	rule nop	{ 'NOP'  { pave 1;} }
	rule trap	{ 'TRAP' { pave 2;} }
	rule add	{ 'ADD' <RxRy> { pave-nrxy 3; }}
	rule sub	{ 'SUB' <RxRy> { pave-nrxy 4; }}
	rule mul	{ 'MUL' <RxRy> { pave-nrxy 5; }}
	rule div	{ 'DIV' <RxRy> { pave-nrxy 6; }}
	rule sti	{ 'STI' <Rx> ',' <offset> <_Ry_>  { pave-roff 7; } }
	rule ldi	{ 'LDI' <offset> <_Rx_>? ',' <Ry> { pave-roff 8 ; } }
	rule lda	{ 'LDA' <offset> <_Rx_>? ',' <Ry> { pave-roff 9 ; } }
	rule ldr	{ 'LDR' <RxRy> { pave-nrxy 10; }}
	rule bze	{ 'BZE' <offset> { pave-noff 11; }}
	rule bnz	{ 'BNZ' <offset> { pave-noff 12; }}
	rule bra	{ 'BRA' <offset> { pave-noff 13; }}
	rule bal	{ 'BAL' <RxRy> { pave-nrxy 14; }}

	rule db		{ 'DB' <digits> }
}

my $str = q:to/END/;


\HALT  
\NOP
\TRAP
\STI R1,0(R1)
L1:
\	ADD R1, R13
\ foo bar baz
LDA L2(R1),R2
L2:
\LDA 27,R2
\LDA L28 (R3),R2
\LDA L29 (R3),R2
\LDA L0,R1

END

$str = slurp "../../examples/fact.vas";
$str = slurp @args[0];
#$str = slurp "test.vas";
#say $str;
my $res =  Asm.parse($str);
#say $res;

#say "Labels:", %labels;
#say "Holes: ", @hole-label, @hole-pc;
#say "Holes: ", @holes;

# fill in the label holes
for @holes -> [$label, $pos] {
	my $where = %labels{$label};
	my @warr = big-end($where);
	for 0..3 {
		@mem[$pos+$_] = @warr[$_];
	}

	#say "TODO filling $label, $pos, $where";
}

#for @mem { printf "%c", $_; }
#spurt "out.vam", @mem, :enc<ascii>
say "Size: ", len;

my $x=0;
for @mem { printf "%02x ", $_; $x++ ; if $x == 8 { print " "} ; if $x == 16 { say ""; $x = 0 ; } }

my $fout = open "out.vam", :w, :b; # , :enc("ascii");
for @mem { $fout.printf("%c", $_); }
$fout.close;
