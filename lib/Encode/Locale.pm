package Encode::Locale;

use strict;
our $VERSION = "0.01";

use base 'Exporter';
our @EXPORT_OK = qw($LOCALE_CODESET decode_argv);

use Encode ();
use Encode::Alias ();

our $ENCODING;
unless ($ENCODING) {
    eval {
	require I18N::Langinfo;
	$ENCODING = I18N::Langinfo::langinfo(I18N::Langinfo::CODESET());
    };

    # final fallback
    $ENCODING ||= "UTF-8";
}

unless (Encode::find_encoding($ENCODING)) {
    die "The locale codeset ($ENCODING) isn't one that perl can decode, stopped";
}

Encode::Alias::define_alias(locale => $ENCODING);
*LOCALE_CODESET = \$ENCODING;

sub decode_argv {
    my $check = @ARGV ? shift : Encode::FB_CROAK;
    for (@ARGV) {
	$_ = Encode::decode(locale => $_, );
    }
}

1;
