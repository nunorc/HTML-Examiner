#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'HTML::Examiner' ) || print "Bail out!
";
}

diag( "Testing HTML::Examiner $HTML::Examiner::VERSION, Perl $], $^X" );
