#!/usr/bin/perl

use strict;
use warnings;

use RPi::PIGPIO ':all';

use FindBin;
use lib "$FindBin::Bin/../lib";

use Icydee::GeoPuzzle;


my $pi = RPi::PIGPIO->connect('127.0.0.1');

my $game = Icydee::GeoPuzzle->new({ fsa_state => 'ping', pi => $pi });

while ($game->fsa_state ne 'end') {
    $game->fsa_check_state;
}

