package Mbot::Plugins::Ripe;
use LWP::UserAgent;
use JSON;

our $VERSION = '0.5';

=head1 NAME

Mbot::Plugins::Ripe - Mbot RIPE data related plugins

=head1 METHODS

=head2 parse - input parser

Responds useful phrase.

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    if ($in->{msg} && $in->{msg} eq 'help')
    {
        my @out = (
            'ripe <command> [arg]',
            '  command:',
            '    asholder <as nr> - responds AS holder. (fe. asholder AS1257)',
            '    geoloc <pref|range|asn|fqn> - responds geolocation info',
            '    dnsrevdel <ip|pref> - responds DNS reverse delegation info',
            '    dnsinfo <ip|fqn> - responds A/AAAA/CNAME/PTR and auth. ns',
        );
        return join("\n", @out);
    }

    if ($in->{msg} && $in->{msg} =~ m/^ripe\s+(.*)/)
    {
        my $cmd = $1;
        my @out;
        if ($cmd =~ m/^asholder\s+(AS\d+)/)
        {
            my $result = _get_data('as-overview', {resource => $1});
            if ($result->{data}->{holder})
            {
                push(@out, "$1: $result->{data}->{holder}");
                return join("\n", @out);
            }
        }
        elsif ($cmd =~ m/^geoloc\s+([\w\/\-\.]+)/)
        {
            my $result = _get_data('geoloc', {resource => $1});
            if ($result->{data}->{locations})
            {
                @out = ('', "$1:");
                foreach my $l (@{$result->{data}->{locations}})
                {
                    my $loc = "$l->{country} $l->{city}";
                    my $map =
"https://maps.google.com/?q=$l->{latitude},$l->{longitude}";
                    my $pref = join(', ', @{$l->{prefixes}});
                    push(@out, "  $loc\n  $map\n  $pref");
                }
                return join("\n", @out);
            }
        }
        elsif ($cmd =~ m/^dnsrevdel\s+([\d\.\:\/]+)/)
        {
            my $result = _get_data('reverse-dns', {resource => $1});
            if ($result->{data}->{delegations})
            {
                @out = ('', "$1:");
                foreach my $d (@{$result->{data}->{delegations}})
                {
                    my $info = {
                        domain => 'Na',
                        descr  => 'Na',
                        ns     => [],
                    };

                    foreach my $i (@$d)
                    {
                        $info->{domain} = $i->{value}
                          if ($i->{key} eq 'domain');
                        $info->{descr} = $i->{value} if ($i->{key} eq 'descr');
                        push(@{$info->{ns}}, $i->{value})
                          if ($i->{key} eq 'nserver');
                    }

                    push(@out,
                        "* $info->{domain}\n    $info->{descr}\n    "
                          . join("\n    ", @{$info->{ns}}));
                }
                return join("\n", @out);
            }
        }
        elsif ($cmd =~ m/^dnsinfo\s+([\w\.\:\-]+)/)
        {
            my $result = _get_data('dns-chain', {resource => $1});
            my $info;

            if ($result->{data}->{reverse_nodes})
            {
                while (my ($ip, $name) =
                    each(%{$result->{data}->{reverse_nodes}}))
                {
                    push(
                        @{$info->{ptr}},
                        "    $ip\n      " . join("\n      ", @$name)
                    );
                }
            }
            else
            {
                push(@{$info->{ptr}}, "    Na");
            }

            if ($result->{data}->{forward_nodes})
            {
                while (my ($name, $ip) =
                    each(%{$result->{data}->{forward_nodes}}))
                {
                    push(
                        @{$info->{forward}},
                        "    $name\n      " . join("\n      ", @$ip)
                    );
                }
            }
            else
            {
                push(@{$info->{forward}}, "    Na");
            }

            if ($result->{data}->{authoritative_nameservers})
            {
                $info->{authns} = join("\n    ",
                    @{$result->{data}->{authoritative_nameservers}});
            }
            else
            {
                $info->{authns} = "Na";
            }

            if ($info)
            {
                @out = ('');
                push(@out, "* forward:\n" . join("\n", @{$info->{forward}}));
                push(@out, "* reverse:\n" . join("\n", @{$info->{ptr}}));
                push(@out, "* authoritative ns:\n    $info->{authns}");
                return join("\n", @out);
            }

        }
    }
}

1;

sub _get_data
{
    my ($call, $params) = @_;

    my $url = "https://stat.ripe.net/data/$call/data.json";

    my @param;
    while (my ($p, $v) = each(%$params))
    {
        push(@param, "$p=$v");
    }

    $url .= '?' . join('&', @param) if (@param);

    my $ua = LWP::UserAgent->new(
        timeout => 5,
        agent   => '',
    );
    my $req = HTTP::Request->new(GET => $url);
    my $res = $ua->request($req);

    my $data;
    if ($res->is_success)
    {
        $data = JSON->new->utf8->decode($res->decoded_content);
    }

    return $data;
}

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
