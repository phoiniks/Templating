#!/usr/bin/perl
use Modern::Perl;
use diagnostics;
use autodie qw( :all );
use Hash::Ordered;
use YAML::XS qw( LoadFile );
use Encode qw( decode encode );
use Expect;
use Log::Log4perl;

Log::Log4perl::init( 'log4perl.conf' );

my $log = Log::Log4perl->get_logger();

$log->info( "BEGINN" );

my $exp = Expect->new;

$exp->log_file("EXPECTATIONS.LOG", "w");

my $parameters = Hash::Ordered->new();

$parameters = LoadFile( "PARAMETERS.YAML" );

my @prompts = $parameters->keys;

$exp->exp_internal( 1 );

my @values = $parameters->values;

$exp->spawn("./Brief.pl", "TEMPLATE_ENTWICKLUNG.tt");

for ( @prompts ) {
    $log->debug( $_ );
    my $value = $parameters->get( encode( "UTF-8", $_ ) );
    $exp->send( encode( "UTF-8", $value ) . "\r" );
    $exp->expect( 1, $_ );
    $log->debug( $value );
    $exp->debug( 3 );
    $exp->exp_continue;
}

$log->info( "ENDE" );

$exp->soft_close();
