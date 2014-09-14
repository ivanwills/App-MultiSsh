package App::MultiSsh;

# Created on: 2014-09-04 17:12:36
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use base qw/Exporter/;

our $VERSION     = 0.03;
our @EXPORT_OK   = qw/hosts_from_map is_host multi_run shell_quote/;
our %EXPORT_TAGS = ();

sub hosts_from_map {
    my ($map) = @_;
    my @hosts;

    my $int_re       = qr/ [0-9a-zA-Z] /xms;
    my $range_re     = qr/ ($int_re) (?:[.][.]|-) ($int_re)/xms;
    my $group_re     = qr/ (?: $int_re | $range_re )       /xms;
    my $seperated_re = qr/ $group_re (?: , $group_re )  *  /xms;
    my $num_range_re = qr/ [[{] ( $seperated_re ) [\]}]    /xms;

    while ( my $host_range = shift @{$map} ) {
        my ($num_range) = $host_range =~ /$num_range_re/;

        if (!$num_range) {
            push @hosts, $host_range;
            next;
            #if ( is_host($host_range) ) {
            #    push @hosts, $host_range;
            #    next;
            #}
            #else {
            #    unshift @{$hosts}, $host_range;
            #    last;
            #}
        }

        my @numbs    = map { /$range_re/ ? ($1 .. $2) : ($_) } split /,/, $num_range;
        my @hostmaps = map { $a=$host_range; $a =~ s/$num_range_re/$_/e; $a } @numbs;

        if ( $hostmaps[0] =~ /$num_range_re/ ) {
            push @{$map}, @hostmaps;
        }
        else {
            push @hosts, @hostmaps;
        }
    }

    return @hosts;
}

sub is_host {
    my $full_name = `host $_[0]`;
    return $full_name !~ /not found/;
}

sub shell_quote {
    my ($text) = @_;

    if ($text =~ /[\s$|><;&*?#]/xms) {
        $text =~ s/'/'\\''/gxms;
        $text = "'$text'";
    }

    return $text;
}

sub multi_run {
    my ($hosts, $remote_cmd, $option) = @_;

    # store child processes if forking
    my @children;

    # loop over each host and run the remote command
    for my $host (@$hosts) {
        my $cmd = "ssh $host " . shell_quote($remote_cmd);
        print "$cmd\n" if $option->{verbose} || $option->{test};
        next if $option->{test};

        if ( $option->{parallel} ) {
            my $child = fork;

            if ( $child ) {
                # parent stuff
                push @children, $child;

                if ( @children == $option->{parallel} ) {
                    warn "Waiting for children to finish\n" if $option->{verbose} > 1;
                    # reap children if reached max fork count
                    while ( my $pid = shift @children ) {
                        waitpid $pid, 0;
                    }
                }
            }
            elsif ( defined $child ) {
                # child code
                if ( $option->{interleave} ) {
                    exec "$cmd 2>&1";
                }
                else {
                    my $out = `$cmd 2>&1`;

                    print "\n$cmd\n";
                    print $out;
                }
                exit;
            }
            else {
                die "Error: $!\n";
            }
        }
        else {
            system $cmd;
        }
    }

    # reap any outstanding children
    wait;
}

1;

__END__

=head1 NAME

App::MultiSsh - Multi host ssh executer

=head1 VERSION

This documentation refers to App::MultiSsh version 0.03

=head1 SYNOPSIS

   use App::MultiSsh;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=over 4

=item C<hosts_from_map ($host)>

Splits C<$host> into all hosts that it represents.

=item C<is_host ($host)>

Gets the full name of C<$host>

=item C<shell_quote ($text)>

Quotes C<$text> for putting into a shell command

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
