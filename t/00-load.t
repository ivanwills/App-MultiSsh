#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2 + 1;
use Test::NoWarnings;
use File::Spec;

use_ok( 'App::MultiSsh' );
diag my $perl = File::Spec->rel2abs($^X);
ok !(system $perl, qw{ -Ilib -c bin/mssh}), "bin/mssh compiles";

diag( "Testing App::MultiSsh $App::MultiSsh::VERSION, Perl $], $^X" );
