## 2010-10-13  Release 0.02

...where I realized that I could not get away with a single locale encoding.
Now `Encode::Locale` provides 4 encoding names that often will map to the same
underlying encoding.  I've used the following names:

    locale        $ENCODING_LOCALE
    locale_fs     $ENCODING_LOCALE_FS
    console_in    $ENCODING_CONSOLE_IN
    console_out   $ENCODING_CONSOLE_OUT

The first one is the encoding specified by the POSIX locale (or the equivalent
on Windows).  This can be set by the user.  The second one (`locale_fs`) is the
encoding that should be used when interfacing with the file system, that is the
encoding of file names.  For some systems (like Mac OS X) this is fixed system
wide and the same for all users.  Last; some systems allow the input and output
encoding for data aimed at the console to differ so there are separate entries
for these.  For classic POSIX systems all 4 of these will all denote the same
encoding.

This release also introduce the function env() as a Unicode interface to the
%ENV hash (the process environment variables).  We don't want to decode the ENV
%values in-place because this also affects what the child processes
observes.  The %ENV hash should always contain byte strings.

## 2010-10-11  Release 0.01

Initial release
