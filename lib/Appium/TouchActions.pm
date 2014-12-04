package Appium::TouchActions;

use Moo;

has 'driver' => (
    is => 'ro',
    required => 1,
    handles => [ qw/execute_script/ ]
);

=method tap ( $x, $y )

Perform a precise tap at a certain location on the device, specified
either by pixels or percentages. All values are relative to the top
left of the device - by percentages, (0,0) would be the top left, and
(1, 1) would be the bottom right.

As per the Appium documentation, values between 0 and 1 will be
interepreted as percentages. (0.5, 0.5) will click in the center of
the screen. Values greater than 1 will be interpreted as pixels. (10,
10) will click at ten pixels away from the top and left edges of the
screen.

    # tap in the center of the screen
    $appium->precise_tap( 0.5, 0.5 )

    # tap a pixel position
    $appium->precise_tap( 300, 500 );

=cut

sub tap {
    my ($self, @coords) = @_;

    my $params = {
        x => $coords[0],
        y => $coords[1]
    };

    $self->execute_script('mobile: tap', $params);

    return $self->driver;
}

1;
