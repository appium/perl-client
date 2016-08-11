package Appium::TouchActions;

# ABSTRACT: Perform touch actions through appium: taps, swipes, scrolling
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
    $appium->tap( 0.5, 0.5 )->perform();

    # tap a pixel position
    $appium->tap( 300, 500 )->perform();

=cut

sub tap {
    my ($self, @coords) = @_;

	my $coordinates = {

        x => $coords[0],
        y => $coords[1]
    };


    #$self->execute_script('mobile: tap', $params);

	my $params = { 'action' => 'tap' , 'options' => $coordinates };

	push @{$self->{'perform_actions'}}, $params;

    return $self->driver;
}



sub press {
	my ($self, @coords) = @_;


	my $coordinates = {

        x => $coords[0],
        y => $coords[1]
    };

	my $params = { 'action' => 'press' , 'options' => $coordinates };

    push @{$self->{'perform_actions'}}, $params;

    return $self->driver;	
}


sub wait {
	my ($self, $wait) = @_;

	my $options = {
		ms => $wait
	};

	my $params = { 'action' => 'wait' , 'options' => $options };

    push @{$self->{'perform_actions'}}, $params;

    return $self->driver;
}


sub moveTo {
	my ($self, @coords) = @_;

    my $coordinates = {

        x => $coords[0],
        y => $coords[1]
    };


	my $params = { 'action' => 'moveTo' , 'options' => $coordinates };

    push @{$self->{'perform_actions'}}, $params;

    return $self->driver;
		
}


sub release {
	my ($self, @options) = @_;

	my $options = {};

	my $params = { 'action' => 'release' , 'options' => $options };	

	push @{$self->{'perform_actions'}}, $params;
 
    return $self->driver;
}


sub longPress {
	my ($self, @coords) = @_;


    my $coordinates = {

        x => $coords[0],
        y => $coords[1],
		duration => $coords[2]
    };

    my $params = { 'action' => 'press' , 'options' => $coordinates };

    push @{$self->{'perform_actions'}}, $params;

    return $self->driver;
}


sub swipe {

	my ($self, @coords) = @_;

	return $self->press($coords[0], $coords[1])->wait($coords[4])->moveTo($coords[2], $coords[3])->release();

}

1;
