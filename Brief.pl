#!/usr/bin/perl
use File::Copy qw( copy );
use Modern::Perl;
use autodie;
use String::TT qw( tt );
use POSIX qw( strftime );
use Carp qw( croak );
use DBI;
use Log::Log4perl;

Log::Log4perl::init( 'log4perl.conf' );

my $log						= Log::Log4perl->get_logger();

my $lokalzeit					= strftime "%A_%d_%B_%Y_%H:%M:%S", localtime;

$log->info( "BEGINN" );

$log->info( $lokalzeit );

if ( !$ARGV[0] ){
    print "Bitte eine Vorlagedatei angeben!\n";
    exit(-1);
}

my $dbh						= DBI->connect("dbi:SQLite:dbname=bewerbungen.db", "", "", { PrintError => 1, RaiseError => 1 } );

my $create					= "CREATE TABLE IF NOT EXISTS bewerbungen(id INTEGER PRIMARY KEY, bezeichnung TEXT,
    firma TEXT, anrede TEXT, ansprechpartner TEXT, strasse TEXT, ort TEXT, gehalt REAL,
    quelle TEXT, telefon TEXT, email TEXT, angebotstext TEXT, anschreiben TEXT,
    zeit DATE DEFAULT (DATETIME('NOW', 'LOCALTIME')))";

my $rv						= $dbh->do( $create );

my $insert					= "INSERT INTO bewerbungen (bezeichnung, firma, anrede, ansprechpartner, strasse,
    ort, gehalt, quelle, telefon, email, angebotstext, anschreiben) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

my $sth						= $dbh->prepare( $insert );


my @input;

print "Bezeichnung: ";
chomp( my $bezeichnung				= <STDIN> );
push @input, $bezeichnung;
    
print "Firma: ";
chomp( my $firma				= <STDIN> );
push @input, $firma;

$firma						=~ s/\&/\\&/g;
    
$log->debug( $firma );

print "Anrede: ";
chomp( my $anrede				= <STDIN> );
push @input, $anrede;

print "Ansprechpartner: ";
chomp( my $ansprechpartner			= <STDIN> );

my $ansprechpartner_vertraulich;

if ( $anrede eq 'vertraulich' ){
    ( $ansprechpartner_vertraulich, undef )	= split / /, $ansprechpartner;
}

push @input, $ansprechpartner;

print "Straße: ";
chomp( my $strasse				= <STDIN> );
push @input, $strasse;

print "Ort: ";
chomp( my $ort					= <STDIN> );
push @input, $ort;

print "Gehalt: ";
chomp( my $gehalt				= <STDIN> );
push @input, $gehalt;

print "Quelle: ";
chomp( my $quelle				= <STDIN> );
push @input, $quelle;

print "Telefon: ";
chomp( my $telefon				= <STDIN> );
push @input, $telefon;

print "E-Mail: ";
chomp( my $email				= <STDIN> );
push @input, $email;


local $/;
open my $datei, "<", $ARGV[0];

$log->debug( $ARGV[0] );

my $vorlage					= <$datei>;

close $datei;


my ($firma_kurz)				= split / /, $input[1], -1;

$log->debug( sprintf "FIRMA_KURZ: %s", $firma_kurz );

my ($bezeichnung_kurz)				= split / /, $input[0], -1;

$log->debug( sprintf "BEZEICHNUNG_KURZ: %s", $bezeichnung_kurz );

my $angebotstext				= $bezeichnung_kurz . "_" . $firma_kurz . "_" . $lokalzeit . "_ANGEBOT.txt";
push @input, $angebotstext;
    
$log->debug( $angebotstext );

my $text					= `xsel`;

$log->debug( $text );

my $ausgabedatei				= $bezeichnung_kurz . "_" . $firma_kurz . "_" . $lokalzeit . ".tex";
push @input, $ausgabedatei;
    
open my $angebot, ">", $angebotstext;

print $angebot $text;

close $angebot;

$sth->execute( @input );

$log->debug( $ausgabedatei );

open my $out, ">", $ausgabedatei;

print $out sprintf "%s", tt $vorlage;

my $output					= `pdflatex $ausgabedatei`
    or croak "Was ist hier los? $!";

close $out;

$log->debug( $output );

copy("bewerbungen.db", "~/bewerbungen_$lokalzeit.db");

$log->info( "ENDE" );

exit;
