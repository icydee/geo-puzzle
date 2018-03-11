#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Icydee::GeoPuzzle;

my $game = Icydee::GeoPuzzle->new({ fsa_state => 'ping' });

while ($game->fsa_state ne 'end') {
    $game->fsa_check_state;
}

