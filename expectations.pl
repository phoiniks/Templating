#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Encode qw( decode encode );
use Data::Dumper;
use diagnostics;
use autodie;
use Hash::Ordered;
use Expect;
use Redis;

my $rds = Redis->new;
$rds->select(1);

my $exp = Expect->new;

# my @grellus = glob("*.txt");

# for ( @grellus ) {
#     unlink $_;
# }

$exp->log_file("EXPECTATIONS.LOG", "w");


my $parameters = Hash::Ordered->new(
    'Bezeichnung'     => 'Softwareentwickler Perl etc.',
    'Firma'           => 'Grellopolis GmbH & Co. KG',
    'Anrede'          => 'Herr',
    'Ansprechpartner' => 'Grellopoulos',
    'Strasse'         => 'Kühnehöfe 25',
    'Ort'             => '22761 Hamburg',
    'Gehalt'          => '60000',
    'Quelle'          => 'stepstone.de',
    'Telefon'         => '040 80 60 37 99',
    'Email'           => 'andreas.grellopoulos\@grellopolis.de',
    'Angebotstext'    => 'grellopolis.txt'
    );

my @prompts = $parameters->keys;

print "@prompts\n";

$exp->exp_internal(1);

my @values = $parameters->values;

$exp->spawn("Brief.pl TEMPLATE_ENTWICKLUNG.tt", @values);

for ( @prompts ) {
    print $_, "\n";
    $exp->expect(1, $_);
    my $value = $parameters->get($_);
    print $value, "\n";
    $exp->send($value . "\n");
    $exp->exp_continue;
}

$exp->soft_close();
