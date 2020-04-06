#!/usr/bin/perl
use Modern::Perl;
use diagnostics;
use autodie qw( :all );
use Hash::Ordered;
use Expect;
use Log::Log4perl;

Log::Log4perl::init( 'log4perl.conf' );

my $log = Log::Log4perl->get_logger();

$log->info( "BEGINN" );

my $exp = Expect->new;

$exp->log_file("EXPECTATIONS.LOG", "w");

my $parameters = Hash::Ordered->new(
    'Bezeichnung: '     => 'Softwareentwickler Perl etc.',
    'Firma: '           => 'Grellopolis GmbH & Co. KG',
    'Anrede: '          => 'Herr',
    'Ansprechpartner: ' => 'Grellopoulos',
    'Straße: '          => 'Kühnehöfe 25',
    'Ort: '             => '22761 Hamburg',
    'Gehalt: '          => '60000',
    'Quelle: '          => 'stepstone.de',
    'Telefon: '         => '040 80 60 37 99',
    'E-Mail: '          => 'andreas.grellopoulos@grellopolis.de',
    'Angebotstext: '    => 'grellopolis.txt',
    );

my @prompts = $parameters->keys;

$exp->exp_internal( 1 );

my @values = $parameters->values;

$exp->spawn("./Brief.pl", "TEMPLATE_ENTWICKLUNG.tt");

for ( @prompts ) {
    $log->debug( $_ );
    my $value = $parameters->get($_);
    $exp->send( $value . "\r" );
    $exp->expect( 1, $_ );
    $log->debug( $value );
    $exp->debug( 3 );
    $exp->exp_continue;
}

$log->info( "ENDE" );

$exp->hard_close();
