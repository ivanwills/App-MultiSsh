#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;

use App::MultiSsh qw/tmux/;

test_layout();
done_testing;

sub test_layout {
    my @data = (
        [['cmd1']],
        [['cmd1', 'cmd2']],
        [
            ['cmd1', 'cmd2'],
            ['cmd3'],
        ],
        [
            ['cmd1', 'cmd2'],
            ['cmd3', 'cmd4'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3'],
            ['cmd4', 'cmd5'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3'],
            ['cmd4', 'cmd5', 'cmd6'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3'],
            ['cmd4', 'cmd5', 'cmd6'],
            ['cmd7'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3'],
            ['cmd4', 'cmd5', 'cmd6'],
            ['cmd7', 'cmd8'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3'],
            ['cmd4', 'cmd5', 'cmd6'],
            ['cmd7', 'cmd8', 'cmd9'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3', 'cmd4'],
            ['cmd5', 'cmd6', 'cmd7', 'cmd8'],
            ['cmd9', 'cmd10'],
        ],
        [
            ['cmd1', 'cmd2', 'cmd3', 'cmd4'],
            ['cmd5', 'cmd6', 'cmd7', 'cmd8'],
            ['cmd9', 'cmd10', 'cmd11'],
        ],
    );

    for my $no (0 .. $#data) {
        my @test = map {'cmd' . ($_ + 1)} 0 .. $no;
        my $ans = App::MultiSsh::layout(@test);
        is_deeply $ans, $data[$no], ($no + 1) . " setup correctly"
            or diag "$no\n", explain $ans, "\n", $data[$no];
    }
}
