#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;


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


my %ngrams;
for ( @$ergebnis ) {
    my $ngram = join " ", @$_;

    $ngrams{ $ngram }++;
}


while( my ( $key, $value ) = each %ngrams ){
    printf "NGRAM: %s, ANZAHL: %d\n", $key, $value;
}


sleep 3;


my @frequencies = sort { $ngrams{ $a } <=> $ngrams{ $b } } keys %ngrams;
for ( @frequencies ){
    printf "NGRAM: %s, ANZAHL: %d\n", $_, $ngrams{ $_ };
}
