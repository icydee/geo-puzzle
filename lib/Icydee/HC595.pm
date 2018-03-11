package Icydee::HC595;

use Moose;
use RPi::PIGPIO;
use Time::HiRes qw(usleep);

# Raspberry pi pin connected to Register Clock
#
has rclk_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 4,
);

# Raspberry pi pin connected to Shift Register Clock
has srclk_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 5,
);

# Raspberry pi pin connected to Serial Data
#
has ser_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 6,
);

has pi => (
    is      => 'rw',
    default => sub {},
};


sub BUILD {
    my ($self) = @_;

    foreach my $pin (qw(clock_pin serial_pin latch_pin)) {
        $self->pi->set_mode($self->$pin, PI_OUTPUT);
        $self->pi->write($self->$pin, LO);
    }
}


# Clock the data
#
sub rclk_pulse {
    my ($self) = @_;

    $self->pi->write($self->rclk_pin, HI);
    usleep(1000);
    $self->pi->write($self->rclk_pin, LO);
}

# Output the data, one byte per device
#   $bytes - ref to array of bytes.
#
sub output {
    my ($self, $bytes) = @_;

    foreach my $byte (@$bytes) {
        foreach my $bit (0..7) {
	    $self->pi->write($self->ser_pin, 0x80 & ($byte << $bit);
            $self->pi->write($self->srclk, HI);
            usleep(1000);
            $self->pi->write($self->srclk, LO);
        }
    }
    $self->rclk_pulse;
}
1;

