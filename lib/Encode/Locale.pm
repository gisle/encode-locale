package Encode::Locale;

use strict;
our $VERSION = "0.02";

use base 'Exporter';
our @EXPORT_OK = qw(
    decode_argv env
    $ENCODING_LOCALE $ENCODING_LOCALE_FS
    $ENCODING_CONSOLE_IN $ENCODING_CONSOLE_OUT
);

use Encode ();
use Encode::Alias ();

our $ENCODING_LOCALE;
our $ENCODING_LOCALE_FS;
our $ENCODING_CONSOLE_IN;
our $ENCODING_CONSOLE_OUT;

if ($^O eq "MSWin32") {
    # If we have the Win32::Console module installed we can ask
    # it for the code set to use
    eval {
	require Win32::Console;
	my $cp = Win32::Console::InputCP();
	$ENCODING_CONSOLE_IN = "cp$cp" if $cp;
	$cp = Win32::Console::OutputCP();
	$ENCODING_CONSOLE_OUT = "cp$cp" if $cp;
    };
    # Invoking the 'chcp' program might also work
    if (!$ENCODING_CONSOLE_IN && qx(chcp) =~ /^Active code page: (\d+)/) {
	$ENCODING_CONSOLE_IN = "cp$1";
    }
}

unless ($ENCODING_LOCALE) {
    eval {
	require I18N::Langinfo;
	$ENCODING_LOCALE = I18N::Langinfo::langinfo(I18N::Langinfo::CODESET());

	# Workaround of Encode < v2.25.  The "646" encoding  alias was
	# introducted in Encode-2.25, but we don't want to require that version
	# quite yet.  Should avoid the CPAN testers failure reported from
	# openbsd-4.7/perl-5.10.0 combo.
	$ENCODING_LOCALE = "ascii" if $ENCODING_LOCALE eq "646";
    };
    $ENCODING_LOCALE ||= $ENCODING_CONSOLE_IN;
}

if ($^O eq "darwin") {
    $ENCODING_LOCALE_FS ||= "UTF-8";
}

# final fallback
$ENCODING_LOCALE ||= $^O eq "MSWin32" ? "cp1252" : "UTF-8";
$ENCODING_LOCALE_FS ||= $ENCODING_LOCALE;
$ENCODING_CONSOLE_IN ||= $ENCODING_LOCALE;
$ENCODING_CONSOLE_OUT ||= $ENCODING_CONSOLE_IN;

unless (Encode::find_encoding($ENCODING_LOCALE)) {
    die "The locale codeset ($ENCODING_LOCALE) isn't one that perl can decode, stopped";
}

Encode::Alias::define_alias(sub {
    no strict 'refs';
    return ${"ENCODING_" . uc(shift)};
}, "locale");

sub decode_argv {
    die if defined wantarray;
    for (@ARGV) {
	$_ = Encode::decode(locale => $_, @_);
    }
}

sub env {
    my $k = Encode::encode(locale => shift);
    my $old = $ENV{$k};
    if (@_) {
	my $v = shift;
	if (defined $v) {
	    $ENV{$k} = Encode::encode(locale => $v);
	}
	else {
	    delete $ENV{$k};
	}
    }
    return Encode::decode(locale => $old) if defined wantarray;
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

=item decode_argv( Encode::FB_CROAK )

This will decode the command line arguments to perl (the C<@ARGV> array) in-place.

The function will by default replace characters that can't be decoded by
"\x{FFFD}", the Unicode replacement character.

Any argument provided is passed as CHECK to underlying Encode::decode() call.
Pass the value C<Encode::FB_CROAK> to have the decoding croak if not all the
command line arguments can be decoded.  See L<Encode/"Handling Malformed Data">
for details on other options for CHECK.

=item env( $uni_key )

=item env( $uni_key => $uni_value )

Interface to get/set environment variables.  Returns the current value as a
Unicode string. The $uni_key and $uni_value arguments are expected to be
Unicode strings as well.  Passing C<undef> as $uni_value deletes the
environment variable named $uni_key.

The returned value will have the characters that can't be decoded replaced by
"\x{FFFD}", the Unicode replacement character.

=item $ENCODING_LOCALE

The encoding name determined to be suitable for the current locale.
L<Encode> know this encoding as "locale".

=item $ENCODING_LOCALE_FS

The encoding name determined to be suiteable for file system interfaces
involving file names.
L<Encode> know this encoding as "locale_fs".

=item $ENCODING_CONSOLE_IN

=item $ENCODING_CONSOLE_OUT

The encodings to be used for reading and writing output to the a console.
L<Encode> know these encodings as "console_in" and "console_out".

=back

=head1 SEE ALSO

L<I18N::Langinfo>, L<Encode>

=head1 AUTHOR

Copyright 2010 Gisle Aas <gisle@aas.no>.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
