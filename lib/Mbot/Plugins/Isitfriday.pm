package Mbot::Plugins::Isitfriday;
use strict;
use warnings;

our $VERSION = '0.2';

=head1 NAME

Mbot::Plugins::Isitfriday - Simple Mbot friday check plugin

=head1 METHODS

=head2 parse - input parser

Responds useful phrase.

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'isitfriday - responds according to current day'
      if ($in->{msg} && $in->{msg} eq 'help');

    if ($in->{msg} && $in->{msg} eq 'isitfriday')
    {
        my $dt   = DateTime->today(time_zone => $in->{conf}->{time_zone});
        my $d_nr = $dt->day_of_week();
        my $out  = 'Not yet';
        if ($d_nr == 4)
        {
            $out = 'Almost there';
        }
        elsif ($d_nr == 5)
        {
            $out = 'Yes it is';
        }
        elsif ($d_nr > 5)
        {
            $out = 'It\'s still weekend. Go back to drink...';
        }
        return $out;
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
