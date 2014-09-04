#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 8 + 1;
use Test::NoWarnings;

use App::MultiSsh qw/shell_quote/;

for my $data (data()) {
    is shell_quote($data->[0]), $data->[1], "$data->[0] translates to $data->[1]";
}

sub data {
    return (
        # unchanged
        [('a')   x 2],
        [('1')   x 2],
        [('a-b') x 2],
        [('2,3') x 2],
        # changed
        [qw/&   '&' /],
        [qw/*   '*' /],
        [qw/a|b 'a|b' /],
        ['a b', "'a b'"],
    );
}
