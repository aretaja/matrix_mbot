#!/usr/bin/perl
#
# mbot.pl
# Copyright 2018 by Marko Punnar <marko[AT]aretaja.org>
# Version: 1.1
# Matrix bot daemon.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# Changelog:
# 1.0 Initial release.
# 1.1 Add configuration values to Mbot object.

use strict;
use warnings;

use Net::Async::Matrix;
use IO::Async::Loop;
use Try::Tiny;
use Config::General;
use DateTime;
use POSIX;
use Mbot;

use Data::Dumper;

# Load config params
my $cfile = $ARGV[0] || '/usr/local/etc/mbot.conf';
my (%conf, $server, $user, $pass, $name, $time_zone, $log, $e_log, $rooms);

# Load config params from file
_loadconf();

# Run daemon
daemonize();

############# SUBROUTINES #############
sub daemonize
{
    while (1)
    {
        # prevent die on error
        try
        {
            _mbot();
        }
        catch
        {
            _writelog("[ERROR] _mbot died -  $_", $e_log);
        };
        sleep 30;
    }
}

sub _loadconf
{
    if (-f $cfile && -r $cfile)
    {
        my $conf_data = Config::General->new(
            -ConfigFile => $cfile,
            -ForceArray => 1
        );
        %conf = $conf_data->getall;
    }
    else
    {
        die("Config file $cfile missing or is not readable");
    }

    $server = $conf{server} || die('server not defined in config file');
    $user   = $conf{user}   || die('user not defined in config file');
    $pass   = $conf{pass}   || die('pass not defined in config file');
    $name   = $conf{name}   || die('name not defined in config file');
    $time_zone = $conf{time_zone}
      || die('time_zone not defined in config file');
    $log = $conf{log_dest} || die('log_dest not defined in config file');
    $e_log = $conf{err_log_dest}
      || die('err_log_dest not defined in config file');
    $rooms = $conf{join_room} || die('join_room not defined in config file');
}

sub _mbot
{
    _writelog("[INFO] Mbot initializing", $log);
    my $loop   = IO::Async::Loop->new;
    my $matrix = Net::Async::Matrix->new(
        server           => $server,
        SSL              => 1,
        first_sync_limit => 0,

        on_room_new => sub {
            my (undef, $room) = @_;

            $room->configure(
                on_message => sub {
                    my ($room, $member, $content, $event) = @_;

                    $room->send_read_receipt(event_id => $event->{event_id},)
                      ->get;
                    if (   $content->{msgtype} eq 'm.text'
                        && $content->{body} =~ m/^$name:\s*(.*)$/)
                    {
                        my $msg   = $1;
                        my $ruser = $member->displayname || 'unknown user';
                        my $in    = {
                            msg   => $msg,
                            dname => $ruser,
                        };

                        _writelog("[INFO] $ruser: message $msg", $log);
                        $room->typing_start;

                        # prevent die on error
                        try
                        {
                            my $mbot = Mbot->new(in => $in, conf => \%conf);
                            $mbot->process();
                            if ($mbot->out)
                            {
                                $room->typing_stop;
                                $room->send_message($mbot->out)->get;
                                _writelog("[INFO] $name: message " . $mbot->out,
                                    $log);
                            }
                            else
                            {
                                _writelog("[ERROR] Mbot confused", $e_log);
                            }
                        }
                        catch
                        {
                            _writelog("[ERROR] Mbot code died - $_", $e_log);
                        };
                    }
                },
            );
        },
    );

    $loop->add($matrix);

    _writelog("[INFO] Logging in to $server as $user", $log);
    $matrix->login(
        user_id  => "\@$user:$server",
        password => $pass,
    )->get;

    _writelog("[INFO] Using displayname $name", $log);
    $matrix->set_displayname($name)->get;

    foreach (@$rooms)
    {
        _writelog("[INFO] Joining $_", $log);
        $matrix->join_room("$_:$server")->get;
        _writelog("[INFO] $name is live on $_", $log);
    }

    $loop->run;
}

sub _writelog
{
    my $message = shift;
    my $out     = shift || 'STDOUT';
    my $format  = '%FT%T';
    my $t_stamp = DateTime->now(time_zone => $time_zone)->strftime($format);
    if ($out eq 'STDERR')
    {
        print STDERR "$t_stamp $message\n";
    }
    else
    {
        open(my $log, ">>", "$out");
        print {$log} "$t_stamp $message\n";
        close($log);
    }
}

__END__
