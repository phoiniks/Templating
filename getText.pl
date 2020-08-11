#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

open my $textfile, "<", $ARGV[0];

$/ = undef;

my $text = <$textfile>;

my ( $rumpf ) = $text =~ m/\\opening\{ .*, \}(.*)\\closing\{ .* \}/ms;

print $rumpf;
