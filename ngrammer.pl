#!/usr/bin/perl

use Modern::Perl;


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


$/ = undef;

open my $text, "<", $ARGV[0];

my @vokabular = split /\s+/, <$text>;

@vokabular = grep { /\w+/ } @vokabular;


my $ergebnis = ngrammer( \@vokabular, $ARGV[1] );

for ( @$ergebnis ) {
    printf "%s\n", join " ", @$_;
}
