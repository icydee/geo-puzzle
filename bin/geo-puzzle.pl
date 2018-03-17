#!/usr/bin/perl

use strict;
use warnings;

use RPi::PIGPIO ':all';

use FindBin;
use lib "$FindBin::Bin/../lib";

use Icydee::GeoPuzzle;
use Icydee::HC595;
use Time::HiRes qw(gettimeofday tv_interval usleep);

my $pi = RPi::PIGPIO->connect('127.0.0.1');

my $game = Icydee::GeoPuzzle->new({ fsa_state => 'ping', pi => $pi });

my $hc595 = Icydee::HC595->new({
    pi  => $pi,
});


my $hi = 0;

while (1) {
    foreach my $output (0..255) {
        my $t0 = [gettimeofday];
        $hc595->output([$output,$hi]);
        my $elapsed = tv_interval($t0, [gettimeofday]);
        print "Elapsed: $elapsed\n";
        usleep(100);
    }
    $hi = 0 if ++$hi == 256;
}


while ($game->fsa_state ne 'end') {
    $game->fsa_check_state;
}

