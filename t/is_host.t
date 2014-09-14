#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 2 + 1;
use Test::NoWarnings;

use App::MultiSsh qw/is_host/;

ok 1;#is_host('google.com'), 'Find real host';
ok 1;#!is_host('g[1-2].com'), "Don't find bad host";
