#!/usr/bin/env perl6
my @args = @*ARGS;

my %labels;
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

sub pave-off(Bool $relative = False) {
	if $offset ~~ Str {
		@holes.push( [$offset, len, $relative] );
		@mem.append( 0xD, 0xE, 0xA, 0xD);
	} else {
		@mem.append(big-end $offset);
	}

}


sub pave-roff($opcode) {
	pave-nrxy $opcode;
	pave-off;
}

sub pave-noff($opcode) {
	pave $opcode;
	pave-off True;
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
	| <ldr> | <bze> | <bnz> | <bra> | <bal> | <sys>
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
	rule sys	{ 'SYS' <offset> {pave-noff 15; }}

	rule db		{ 'DB' <digits> { my $n = "$<digits>".Int; @mem.append( $n ); }}
}


my $str = slurp @args[0];
my $res =  Asm.parse($str);

# fill in the label holes
for @holes -> [$label, $pos, $rel] {
	my $where = %labels{$label};
	my $val   = $where;
	if $rel { $val = $where - $pos +1; }
	my @warr = big-end($val);
	for 0..3 { @mem[$pos+$_] = @warr[$_]; }
}


#my $x=0;
#for @mem { printf "%02x ", $_; $x++ ; if $x == 8 { print " "} ; if $x == 16 { say ""; $x = 0 ; } }

my $fout = open "out.vam", :w, :bin;
for @mem { $fout.write(Buf.new($_)); }
$fout.close;
