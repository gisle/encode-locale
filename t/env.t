#!perl -w

use strict;
use Test;
plan tests => 7;

use Encode::Locale qw(env);

$ENV{foo} = "bar";
ok(env("foo"), "bar");
ok(env("foo", "baz"), "bar");
ok(env("foo"), "baz");
ok($ENV{foo}, "baz");
ok(env("foo", undef), "baz");
ok(env("foo"), undef);
ok(!exists $ENV{foo});
