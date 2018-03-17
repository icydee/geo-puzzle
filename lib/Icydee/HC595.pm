package Icydee::HC595;

use Moose;
use RPi::PIGPIO ':all';
use Time::HiRes qw(usleep);

# Raspberry pi pin connected to Register Clock (chip pin 12)
#
has latch_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 4,
);

# Raspberry pi pin connected to Shift Register Clock (chip pin 11)
has clock_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 5,
);

# Raspberry pi pin connected to Serial Data (chip pin 14)
#
has data_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 6,
);

has pi => (
    is      => 'rw',
    default => sub {},
);


sub BUILD {
    my ($self) = @_;

    foreach my $pin (qw(latch_pin clock_pin data_pin)) {
        $self->pi->set_mode($self->$pin, PI_OUTPUT);
        $self->pi->write($self->$pin, LOW);
    }
}


# Output the data, one byte per device
#   $bytes - ref to array of bytes.
#
sub output {
    my ($self, $bytes) = @_;

    foreach my $byte (reverse @$bytes) {
        #$self->pi->write($self->latch_pin, LOW);
        print("Output byte $byte\n");
        foreach my $bit (0..7) {
            my $state = 0x80 & ($byte << $bit) ? HI : LOW;
            $self->pi->write($self->data_pin, $state);
            usleep(1);
            $self->pi->write($self->clock_pin, HI);
            usleep(1);
            $self->pi->write($self->clock_pin, LOW);
            usleep(1);
        }
    }
    $self->pi->write($self->latch_pin, HI);
    usleep(1);
    $self->pi->write($self->latch_pin, LOW);
    usleep(1);
}
1;

