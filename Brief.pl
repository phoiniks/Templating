#!/usr/bin/perl
use Modern::Perl;
use autodie;
use String::TT qw( tt strip );
use POSIX qw( strftime );
use Log::Log4perl;

Log::Log4perl::init( 'log4perl.conf' );

my $log = Log::Log4perl->get_logger();

my $lokalzeit              = strftime "%A_%d_%B_%Y_%H:%M:%S", localtime;

$log->info( "BEGINN" );

$log->info( $lokalzeit );

print "Bezeichnung: ";
chomp(my $bezeichnung      = <STDIN>);

print "Firma: ";
chomp(my $firma            = <STDIN>);

$firma =~ s/\&/\\&/g;

print "Anrede: ";
chomp(my $anrede           = <STDIN>);

print "Ansprechpartner: ";
chomp(my $ansprechpartner  = <STDIN>);

print "Straße: ";
chomp(my $strasse          = <STDIN>);

print "Ort: ";
chomp(my $ort              = <STDIN>);

print "Gehalt: ";
chomp(my $gehalt           = <STDIN>);

print "Quelle: ";
chomp(my $quelle           = <STDIN>);

print "Telefon: ";
chomp(my $telefon          = <STDIN>);

print "E-Mail: ";
chomp(my $email            = <STDIN>);

print "Angebotstext: ";
chomp(my $angebot          = <STDIN>);

local $/;
open my $datei, "<", $ARGV[0];

$log->debug( $ARGV[0] );

my $vorlage                = <$datei>;

close $datei;


my ($firma_kurz) = split / /, $firma, -1;

$log->debug( sprintf "FIRMA_KURZ: %s", $firma_kurz );

my ($bezeichnung_kurz) = split / /, $bezeichnung, -1;

$log->debug( sprintf "BEZEICHNUNG_KURZ: %s", $bezeichnung_kurz );

my $ausgabedatei           = $bezeichnung_kurz . "_" . $firma_kurz . "_" . $lokalzeit . ".tex";

$log->debug( $ausgabedatei );

open my $out, ">", $ausgabedatei;

print $out sprintf "%s", tt $vorlage;

close $out;

my $output = `pdflatex $ausgabedatei`;

$log->debug( $output );

$log->info( "ENDE" );

exit;
