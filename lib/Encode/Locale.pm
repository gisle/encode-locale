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
    die if defined wantarray;
    for (@ARGV) {
	$_ = Encode::decode(locale => $_, );
    }
}

1;

__END__

=head1 NAME

Encode::Locale - Determine the locale encoding

=head1 SYNOPSIS

  use Encode::Locale;
  use Encode;

  $string = decode(locale => $octets);

  binmode(STDIN, ":encoding(locale)");
  binmode(STDOUT, ":encoding(locale)");

=head1 DESCRIPTION

Perl uses Unicode to represent strings internally but many of the interfaces it
has to the outside world is still byte based.  Programs therefore needs to decode
strings that enter the program from the outside and encode them again on the way
out.

The POSIX locale system is used to specify both the language conventions to use
and the prefered character set to consume and output.  This module looks up the
charset (called a CODESET in the locale jargon) and arrange for the L<Encode>
module to know this encoding under the name "locale".

In addition the following functions and variables are provided:

=over

=item decode_argv()

This will decode the command line arguments to perl (the C<@ARGV> array) in-place.

=item $LOCALE_CODESET

The encoding name determined to be suitable for the current locale.

=back

=head1 SEE ALSO

L<I18N::Langinfo>, L<Encode>

=head1 AUTHOR

Copyright 2010 Gisle Aas <gisle@aas.no>.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
