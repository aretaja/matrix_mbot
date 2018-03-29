#!/usr/bin/perl
use Test::Most;

use Mbot;

my $in = { msg   => 'help', };
my $mbot = Mbot->new(in => $in);
ok(1, 'test');
ok( defined $mbot, 'Mbot->new() returned something' );
ok( $mbot->isa('Mbot'), '  and it\'s the right class' );
$mbot->process();
ok( $mbot->out, 'Mbot->process() returned something' );

done_testing();
