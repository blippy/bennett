#!/usr/bin/env perl6
# ignore for now
#use Switch;

my @bcode;

sub halt { @bcode.append: 0;}
sub nop { @bcode.append: 1;}
sub trap { @bcode.append: 2; }
sub lda($off, $rx , $ry) { @bcode.append: (9, $off, $rx, $ry); }

sub run {
	my $ip = 0;
	say @bcode[0];
	loop { 
		given @bcode[$ip++] {
			when 0 { print "time to die"; last; } # halt
			when 1 { } # nop
			when 9 {  }
			default   { say "Guru meditation"; }
		}
	}

}


nop;
lda 88, 0, 15; # set register 15 to X
trap;
halt;


say @bcode;
run;

