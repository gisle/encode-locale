use strict;
use Test;
plan tests => 2;

use Encode;
use Encode::Locale;

my $skip = not ( $^O eq "darwin" and eval "use Encode::UTF8Mac; 1" );

skip(
    $skip,
    sub {
        Encode::find_encoding('locale_fs')->name() eq 'utf-8-mac';
    }
);

skip(
    $skip,
    sub {
        use utf8;
        Encode::decode('locale_fs', "e\xCC\x81") eq "é";
    }
);
