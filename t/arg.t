#!perl -w

use strict;
use Test;
plan tests => 1;

use Encode::Locale qw($LOCALE_CODESET decode_argv);

print "# LOCALE_CODESET is $LOCALE_CODESET\n";
decode_argv();

my $i;
for my $arg (@ARGV) {
    print "# ", ++$i, ": \"";
    for (split(//, $arg)) {
	if (ord() > 32 && ord() < 128) {
	    print $_;
	}
	elsif (ord() < 256) {
	    printf "\\x%02X", ord();
	}
	else {
	    printf "\\x{%04X}", ord();
	}
    }
    print "\"\n";
}

# fake it :-)
ok(1);
