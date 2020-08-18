#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;

my @liste = qw( Dies ist eine blöde Liste );


sub ngrammer {
    my $woerter = shift;
    my $laenge = shift;
    my @ergebnis;

    $laenge -= 1;
    
    for ( 0..scalar @$woerter ) {
	if ( $laenge + $_ < scalar @$woerter ) {
	    push @ergebnis, [@$woerter[$_..$_ + $laenge]];
	}
    }
    
    return \@ergebnis;
}


my $ergebnis = ngrammer( \@liste, 3 );

print Dumper( $ergebnis );

for ( @$ergebnis ) {
    print "@$_ ";
}
