#!/usr/bin/perl
use Modern::Perl;
use diagnostics;
use autodie qw( :all );
use Hash::Ordered;
use Expect;
use Log::Log4perl;
use utf8;
use YAML::XS qw( DumpFile );

Log::Log4perl::init( 'log4perl.conf' );

my $log = Log::Log4perl->get_logger();

$log->info( "BEGINN" );

my $parameters = Hash::Ordered->new(
    'Bezeichnung: '     => 'BEZEICHNUNG',
    'Firma: '           => 'FIRMA',
    'Kennziffer: '      => 'KENNZIFFER',
    'Anrede: '          => 'ANREDE',
    'Ansprechpartner: ' => 'ANSPRECHPARTNER',
    'Straße: '          => 'STRASSE',
    'Ort: '             => 'ORT',
    'Gehalt: '          => 'GEHALT',
    'Quelle: '          => 'QUELLE',
    'Telefon: '         => 'TELEFON',
    'E-Mail: '          => 'E-MAIL',
    'Angebotstext: '    => 'ANGEBOTSTEXT',
    );

my $yaml = DumpFile( "PARAMETERS.YAML", $parameters);

$log->info("ENDE");
