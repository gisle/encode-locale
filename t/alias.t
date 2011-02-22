#!perl -w
use strict;
use Test;
plan tests => 8;

use Encode::Locale;
use Encode qw(find_encoding);

ok find_encoding('locale'), find_encoding $Encode::Locale::ENCODING_LOCALE;
ok find_encoding('Locale'), find_encoding $Encode::Locale::ENCODING_LOCALE;

ok find_encoding('locale_fs'), find_encoding $Encode::Locale::ENCODING_LOCALE_FS;
ok find_encoding('Locale_FS'), find_encoding $Encode::Locale::ENCODING_LOCALE_FS;

ok find_encoding('console_in'), find_encoding $Encode::Locale::ENCODING_CONSOLE_IN;
ok find_encoding('Console_IN'), find_encoding $Encode::Locale::ENCODING_CONSOLE_IN;

ok find_encoding('console_out'), find_encoding $Encode::Locale::ENCODING_CONSOLE_OUT;
ok find_encoding('Console_OUT'), find_encoding $Encode::Locale::ENCODING_CONSOLE_OUT;

