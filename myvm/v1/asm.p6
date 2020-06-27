grammar Asm {
	rule TOP 	{ <loioc>* }
	rule loioc 	{ <comment> | <loi> | <blank> } # label or instruction or comment
	token blank	{ \s+ }
	token comment	{ '\\' \N* \n }
	rule label	{ <id>  <colon> { say "LABEL $<id>"; } }
	rule colon 	{ ':' }
	rule instr 	{ <id> { say "found instruction $<id>"; } }
	token Rx	{ 'R' <digits> }
	token _Rx_	{ '(' <Rx> ')' }
	token Ry	{ 'R' <digits> }
	token _Ry_	{ '(' <Ry> ')' }
	token id 	{ <[a..zA..Z0..9_]>+ }
	token offset	{ ('-'? <digits>)|<id> }
	token digits	{ <[0..9]>+ }
	rule RxRy	{ <Rx> ',' <Ry> }

	rule loi 	{ <halt> | <nop> | <trap> | <add> | <sub> | <mul> 
				| <div> | <sti> | <ldi> | <lda> 
				| <ldr> | <bze> | <bnz> | <bra> | <bal>
				| <db>  | <label> }
	rule nop	{ 'NOP' }
	rule halt	{ 'HALT' }
	rule trap	{ 'TRAP' }
	rule add	{ 'ADD' <RxRy> }
	rule sub	{ 'SUB' <RxRy> }
	rule mul	{ 'MUL' <RxRy> }
	rule div	{ 'DIV' <RxRy> }
	rule sti	{ 'STI' <Rx> ',' <offset> <_Ry_> { say "found STI"; } }
	rule ldi	{ 'LDI' <offset> <_Rx_>  ',' <Ry> }
	rule lda	{ 'LDA' <offset> <_Rx_>? ',' <Ry> { say "found LDA $<offset>"; } }
	rule ldr	{ 'LDR' <RxRy> }
	rule bze	{ 'BZE' <offset> }
	rule bnz	{ 'BNZ' <offset> }
	rule bra	{ 'BRA' <offset> }
	rule bal	{ 'BAL' <RxRy> }

	rule db		{ 'DB' <digits> }
}

my $str = q:to/END/;


HALT  
NOP
TRAP
STI R1,0(R1)
L1:
	ADD R1, R13
\ foo bar baz
LDA 26(R1),R2
LDA 27,R2
LDA L0,R1

END

$str = slurp "../../examples/fact.vas";
#say $str;
my $res =  Asm.parse($str);
