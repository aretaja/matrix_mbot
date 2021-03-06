package Mbot::Plugins::Decide;
use strict;
use warnings;

use List::Util 'shuffle';

our $VERSION = '0.3';

=head1 NAME

Mbot::Plugins::Decide - Simple Mbot decision plugin

=head1 METHODS

=head2 parse - input parser

Responds random from submitted parts.

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'decide <part1> or <part2> or .. - responds random <part?>'
      if ($in->{msg} && $in->{msg} eq 'help');

    my (@parts);
    if ($in->{msg} && $in->{msg} =~ m/^decide\s+(.*)/)
    {
        @parts = split(/\s+or\s+/, $1) if ($1);
        if (@parts)
        {
            my @shuffled = shuffle(@parts);
            return $shuffled[0];
        }
    }
}

1;

__END__

=head1 AUTHOR

Marko Punnar <marko@aretaja.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Marko Punnar.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>

=cut
