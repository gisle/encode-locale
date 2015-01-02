#!perl -w

use strict;
use warnings;
use Test::More tests => 8;

use Encode::Locale;
use Encode qw(find_encoding);

sub cmp_encoding {
    my ($arg, $var) = @_;
    is find_encoding($arg), find_encoding(${ $Encode::Locale::{$var} }),
        "$arg eq $var";
}

cmp_encoding 'locale', 'ENCODING_LOCALE';
cmp_encoding 'Locale', 'ENCODING_LOCALE';

cmp_encoding 'locale_fs', 'ENCODING_LOCALE_FS';
cmp_encoding 'Locale_FS', 'ENCODING_LOCALE_FS';

cmp_encoding 'console_in', 'ENCODING_CONSOLE_IN';
cmp_encoding 'Console_IN', 'ENCODING_CONSOLE_IN';

cmp_encoding 'console_out', 'ENCODING_CONSOLE_OUT';
cmp_encoding 'Console_OUT', 'ENCODING_CONSOLE_OUT';
