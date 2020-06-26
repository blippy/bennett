my $contents = slurp "../../examples/fact.vam", :bin;
#say $contents.encoding("ASCII").bytes;
say $contents;

loop (my $i = 0; $i < $contents.elems /4; 0) {
	my $ins = $contents[$i];
	print $ins, "\t" ;
	given $ins {
		#when 0 { say "HALT"; 0; }
		#when 1 { say "NOP";}
		#when 2 {say "TRAP"; }
		when 7 {say "STI"; $i += 6; }
		when 9 { say "LDA"; $i += 6; }
		when 10 { say "LDR"; $i += 2; }
		default { say "unknown";  $i += 6; }
	}
}
