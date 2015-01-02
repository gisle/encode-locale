#!perl -w

use strict;
use warnings;
use Test::More tests => 1;

use Encode::Locale qw($ENCODING_LOCALE decode_argv);

note "ENCODING_LOCALE is $ENCODING_LOCALE\n";
decode_argv();

my $i = 0;
for my $arg (@ARGV) {
    note $i++ . ': ' . prettify($arg);
}

sub prettify {
    my $text = shift;
    my @r;
    for (split(//, $text)) {
	if (ord() > 32 && ord() < 128) {
	    push @r, $_;
	}
	elsif (ord() < 256) {
	    push @r, sprintf "\\x%02X", ord();
	}
	else {
	    push @r, sprintf "\\x{%04X}", ord();
	}
    }
    join '', @r;
}

# fake it :-)
ok(1);
