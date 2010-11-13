#!perl -w

use strict;
use Test;
plan tests => 1;

use Encode::Locale qw($ENCODING_LOCALE decode_argv);

print "# ENCODING_LOCALE is $ENCODING_LOCALE\n";
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
