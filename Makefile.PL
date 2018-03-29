use inc::Module::Install;    #libmodule-install-perl

name 'Mbot';

abstract 'matrix.org bot';
author 'Marko Punnar <marko@aretaja.org>';
version '1.8';
license 'gpl';
all_from 'lib/Mbot.pm';

requires 'Net::Async::Matrix';    # no package
requires 'IO::Async::SSL';        # no package
requires 'IO::Async::Loop';       # no package
requires 'Config::General';       # libconfig-general-perl
requires 'DateTime';              # libdatetime-perl
requires 'Moose';                 # libmoose-perl
requires 'LWP::UserAgent';        # libwww-perl
requires 'JSON';                  # libjson-perl
requires 'Module::Pluggable';     # libmodule-pluggable-perl
test_requires 'Test::Most';       # libtest-most-perl
test_requires 'Test::Strict';     # libtest-strict-perl

install_script glob('script/*.pl');
auto_install;
WriteAll;
