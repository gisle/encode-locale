#!perl -Tw
use strict;

# taint mode testing as seen in WWW::Mechanize

use Test;
BEGIN {
    plan tests => 1;
}
my @warns;
BEGIN {
    $SIG{__WARN__} = sub { push @warns, @_ };
}
BEGIN {
    delete @ENV{qw( PATH IFS CDPATH ENV BASH_ENV )};  # Placates taint-unsafe Cwd.pm in 5.6.1
}

require Encode::Locale;


ok "@warns", "";
