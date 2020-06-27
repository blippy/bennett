grammar Asm {
	rule TOP 	{ <loioc>* }
	rule loioc 	{ <comment> | <loi> } # label or instruction or comment
	token comment	{ '\\' \N* \n }
	#rule loi 	{ <id>  (<colon> | <instr> ) } # label or instruction
	rule label	{ ( <id>  <colon>) }
	rule colon 	{ ':' { say "found colon"; } }
	rule instr 	{ <id> { say "found instruction $<id>"; } }
	token Rx	{ 'R' <digits> }
	token Ry	{ 'R' <digits> }
	token id 	{ <[a..zA..Z0..9_]>+ }
	token offset	{ '-'? <digits> }
	token digits	{ <[0..9]>+ }
	rule RxRy	{ <Rx> ',' <Ry> }

	rule loi 	{ <halt> | <nop> | <trap> | <add> | <sub> | <mul> | <div> | <sti> | <ldi> | <lda> | <label> }
	rule nop	{ 'NOP' }
	rule halt	{ 'HALT' }
	rule trap	{ 'TRAP' }
	rule add	{ 'ADD' <RxRy> }
	rule sub	{ 'SUB' <RxRy> }
	rule mul	{ 'MUL' <RxRy> }
	rule div	{ 'DIV' <RxRy> }
	rule sti	{ 'STI' <Rx> ',' <offset> <Ry> }
	rule ldi	{ 'LDI' <offset> '(' <Rx> ')' ',' <Ry> }
	rule lda	{ 'LDA' <offset> '(' <Rx> ')' ',' <Ry> { say "found LDA $<offset>"; } }
}

my $str = q:to/END/;
HALT  
NOP
TRAP
L1:
	ADD R1, R13
\ foo bar baz
LDA 26(R1),R2

END

my $res =  Asm.parse($str);
