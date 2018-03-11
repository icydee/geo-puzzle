package Icydee::GeoPuzzle;

use Moose;
use FSA::Engine::Transition;

with 'FSA::Engine';

has counter => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
);

sub _build_fsa_states {
    my ($self) = @_;

    return {
        ping => { entry_action => sub {print "ping\n"}},
        pong => { entry_action => sub {print "pong\n"}},
	end  => { },
    }
}

sub _build_fsa_transitions {
    my ($self) = @_;

    return {
        ping => {
            volley => FSA::Engine::Transition->new({
                test    => sub {$self->counter < 20},
                action  => sub {$self->counter($self->counter + 1)},
                state   => 'pong',
            }),
            end => FSA::Engine::Transition->new({
                test    => sub {$self->counter >= 20},
                action  => sub {print "Game over\n"},
                state   => 'end',
            }),
        },
        pong => {
            return_volley => FSA::Engine::Transition->new({
                test    => sub {1},
                state   => 'ping',
            }),
        },
        end => {
        },
    };
}
1;

