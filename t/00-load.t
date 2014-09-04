#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2 + 1;
use Test::NoWarnings;

use_ok( 'App::MultiSsh' );
ok !(system qw{perl -Ilib -c bin/mssh}), "bin/mssh compiles";

diag( "Testing App::MultiSsh $App::MultiSsh::VERSION, Perl $], $^X" );
