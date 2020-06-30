#!/usr/bin/env perl6

#say $*ARGFILES;

#sub MAIN(Str $file where *.IO.f ) {
#	say $file;
#}
#

my @args =  @*ARGS;

#my $contents = slurp "../../examples/fact.vam", :bin;
my $contents = slurp @args[0], :bin;
#say $contents;

#say $contents.elems;

my $i = 0;

my $rx;
my $ry;
my int32 $offset;

sub rxy() {
	my byte $b = $contents[$i];
	$rx = $b +> 4; # high nibble
	$rx = "R$rx";
	$ry = $b +& 0xf; # low nibble
	$ry = "R$ry";
	$i++;
	#say "rx= $rx, ry= $ry";
}

sub offset() {
	#$offset = $contents[$i+0] + ($contents[$i+1] +< 8) + ($contents[$i+2] +< 16) + ($contents[$i+3] +< 24);
	$offset = ($contents[$i+0] +< 24) + ($contents[$i+1] +< 16) + ($contents[$i+2] +< 8) + ($contents[$i+3] +< 0);
	$i += 4;
}

sub rxyo() { rxy ; offset ; }

#loop (my $i = 0; $i < $contents.elems ; 0) {
while ($i < $contents.elems) {
	my $ins = $contents[$i];
	printf "%05dd\t", $i;
	$i++;
	#print $ins, "\t" ;
	given $ins {
		when 0 	{ say "HALT"; }
		when 1 	{ say "NOP";  }
		when 2 	{ say "TRAP"; }
		when 3 	{ rxy ; say "ADD $rx, $ry";  }
		when 4 	{ rxy ; say "SUB $rx, $ry";  }
		when 5	{ rxy ; say "MUL $rx, $ry";  }
		when 6	{ rxy ; say "DIV $rx, $ry";  }
		when 7 	{ rxyo ; say "STI $rx, $offset ($ry)";  }
		when 8 	{ rxyo ; say "LDI $offset ($rx), $ry";  }
		when 9 	{ rxyo ; say "LDA $offset ($rx), $ry";  }
		when 10 { rxy ; say "LDR $rx, $ry"; }
		when 11 { offset ; say "BZE $offset";  }
		when 12 { offset ; say "BNZ $offset"; }
		when 13 { offset ; say "BRA $offset";}
		when 14 { rxy; say "BAL $rx, $ry";  }
		when 15 { offset ; say "SYS $offset";}
		default { say "???";  }
	}
	#last if $i >= $contents.elems;
}
