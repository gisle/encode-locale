#!perl -w
use strict;

use Test::More tests => 1;
my @warns;
BEGIN {
    $SIG{__WARN__} = sub { push @warns, @_ };
}

use Encode::Locale;

is "@warns", "";


