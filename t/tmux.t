#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 1 + 1;
use Test::NoWarnings;

use App::MultiSsh qw/shell_quote/;

ok 1;
