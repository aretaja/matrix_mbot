package Mbot;

use Module::Pluggable search_path => 'Mbot::Plugins', require => 1;
use Moose;

our $VERSION = '0.2';

has 'in' => (is => 'ro', isa => 'HashRef', required => 1);
has 'out' => (is => 'rw', isa => 'Str');

=head1 NAME

Mbot - Matrix Bot message parser

=head1 METHODS

=head2 process - finds plugin to process input

Takes message string and returns answer string.

    $in = {
        msg   => $msg,
        dname => $ruser,
        conf  => \%conf,
    };
    $mbot = Mbot->new(in => $in);
    $mbot->process();
    result = $mbot->out;

=cut

sub process
{
    my $self = shift;

    my @out;
    foreach my $plugin ($self->plugins)
    {
        next unless $plugin->can('parse');
        my $result = $plugin->parse($self->in);
        if ($result)
        {
            push(@out, $result);
        }
    }

    unshift(@out, '') if (@out && scalar(@out) > 1);

    $self->out(join("\n", @out)) if (@out);
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
