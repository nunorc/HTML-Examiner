use strict;
use warnings;
use ExtUtils::MakeMaker;

# yapp -m HTML::Examiner::Parser -o lib/HTML/Examiner/Parser.pm lib/HTML/Examiner/Parser.yp

my $MY_YAPP = `which yapp`;
chomp $MY_YAPP;
$MY_YAPP eq '' and die "install Parse::Yapp";

`$MY_YAPP -m HTML::Examiner::Parser -o lib/HTML/Examiner/Parser.pm lib/HTML/Examiner/Parser.yp`;
if ($? == 0) { print "Building lib/HTML/Examiner/Parser.pm\n"; }
else { print "Building lib/HTML/Examiner/Parser.pm (failed)\n"; }

WriteMakefile(
    NAME                => 'HTML::Examiner',
    AUTHOR              => q{Nuno Carvalho <smash@cpan.org>},
    VERSION_FROM        => 'lib/HTML/Examiner.pm',
    ABSTRACT_FROM       => 'lib/HTML/Examiner.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Template' => 0,
        'XML::DT' => 0,
        'Parse::Yapp' => 0,
        'Parse::Yapp::Driver' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTML-Examiner-*' },
);
