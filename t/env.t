#!perl -w

use strict;
use Test;
plan tests => 13;

use Encode::Locale qw(env);

$ENV{foo} = "bar";
ok(env("foo"), "bar");
ok(env("foo", "baz"), "bar");
ok(env("foo"), "baz");
ok($ENV{foo}, "baz");
ok(env("foo", undef), "baz");
ok(env("foo"), undef);
ok(!exists $ENV{foo});

Encode::Locale::reinit("cp1252");
$ENV{"m\xf6ney"} = "\x80uro";
ok(env("m\xf6ney", "\x{20AC}"), "\x{20AC}uro");
ok(env("m\xf6ney"), "\x{20AC}");
ok($ENV{"m\xf6ney"}, "\x80");
ok(env("\x{20AC}", 1), undef);
ok(env("\x{20AC}"), 1);
ok($ENV{"\x80"}, 1);
