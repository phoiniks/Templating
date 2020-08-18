#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;

$/ = undef;
open my $latex, "<", $ARGV[0];

my $text = <$latex>;

$text =~ m/\%\%ANFANG(.*)\%\%ENDE/gismo;

my $rumpf = $1;

$rumpf =~ s/^\s//;

print $rumpf;
