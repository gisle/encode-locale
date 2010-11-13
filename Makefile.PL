require 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'Encode::Locale',
    VERSION_FROM => 'lib/Encode/Locale.pm',
    ABSTRACT_FROM => "lib/Encode/Locale.pm",
    AUTHOR => 'Gisle Aas <gisle@activestate.com>',
    LICENSE => "perl",
    MIN_PERL_VERSION => 5.008,
    PREREQ_PM    => {
	'Encode' => 2,
	'Encode::Alias' => 0,
    },
    META_MERGE => {
        resources => {
            repository => 'http://github.com/gisle/encode-locale',
        },
        recommends => {
            'I18N::Langinfo' => 0,
	    'Win32::Console' => 0,
        },
    },
    BUILD_REQUIRES => {
        Test => 0,
    },
);

BEGIN {
    # compatibility with older versions of MakeMaker
    my $developer = -d ".git";
    my %mm_req = (
        LICENCE => 6.31,
        META_MERGE => 6.45,
        META_ADD => 6.45,
        MIN_PERL_VERSION => 6.48,
        BUILD_REQUIRES => 6.56,
    );
    undef(*WriteMakefile);
    *WriteMakefile = sub {
        my %arg = @_;
        for (keys %mm_req) {
            unless (eval { ExtUtils::MakeMaker->VERSION($mm_req{$_}) }) {
                warn "$_ $@" if $developer;
                delete $arg{$_};
            }
        }
        ExtUtils::MakeMaker::WriteMakefile(%arg);
    };
}
