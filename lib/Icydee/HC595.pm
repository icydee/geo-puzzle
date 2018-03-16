package Icydee::HC595;

use Moose;
use RPi::PIGPIO ':all';
use Time::HiRes qw(usleep);

# Raspberry pi pin connected to Register Clock (chip pin 12)
#
has rclk_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 4,
);

# Raspberry pi pin connected to Shift Register Clock (chip pin 11)
has srclk_pin => (
    is      => 'rw',
    isa     => 'Int',
    default => 5,
);

# Raspberry pi pin connected to Serial Data (chip pin 14)
#
has ser_pin => (
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

    foreach my $pin (qw(rclk_pin srclk_pin ser_pin)) {
        $self->pi->set_mode($self->$pin, PI_OUTPUT);
        $self->pi->write($self->$pin, LOW);
    }
}


# Clock the data
#
sub rclk_pulse {
    my ($self) = @_;

    $self->pi->write($self->rclk_pin, HI);
    usleep(1);
    $self->pi->write($self->rclk_pin, LOW);
    usleep(1);
}

sub srclk_pulse {
    my ($self) = @_;

    $self->pi->write($self->srclk_pin, HI);
    usleep(1);
    $self->pi->write($self->srclk_pin, LOW);
    usleep(1);
}

# Output the data, one byte per device
#   $bytes - ref to array of bytes.
#
sub output {
    my ($self, $bytes) = @_;

    foreach my $byte (@$bytes) {
        foreach my $bit (0..7) {
            my $state = 0x80 & ($byte << $bit) ? HI : LOW;
            $self->pi->write($self->ser_pin, $state);
            $self->srclk_pulse;
        }
    }
    $self->rclk_pulse;
}
1;

