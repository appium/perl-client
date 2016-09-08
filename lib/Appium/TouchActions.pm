package Appium::TouchActions;

# ABSTRACT: Perform touch actions through appium: taps, swipes, scrolling
use Moo;

has 'driver' => (
    is => 'ro',
    required => 1
    
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

	my $params = { action => 'tap' , options => $coordinates };
	push @{$self->{'perform_actions'}}, $params;
    return $self->driver;
}

=method press ( $x, $y )

Perform a precise press at a certain location on the device, specified
either by pixels or percentages. All values are relative to the top
left of the device - by percentages, (0,0) would be the top left, and
(1, 1) would be the bottom right.

As per the Appium documentation, values between 0 and 1 will be
interepreted as percentages. (0.5, 0.5) will click in the center of
the screen. Values greater than 1 will be interpreted as pixels. (10,
10) will click at ten pixels away from the top and left edges of the
screen.

    # press in the center of the screen
    $appium->press( 0.5, 0.5 )->perform();

    # press a pixel position
    $appium->press( 300, 500 )->perform();

=cut

sub press {
	my ($self, @coords) = @_;

	my $coordinates = {
        x => $coords[0],
        y => $coords[1]
    };

	my $params = { action => 'press' , options => $coordinates };
    push @{$self->{'perform_actions'}}, $params;
    return $self->driver;
}

=method wait ( $x, $y )

Perform a wait action, specified duration in miliseconds

    #wait for action to complete
    $appium->wait( 1000 )->perform();

=cut

sub wait {
	my ($self, $wait) = @_;

	my $options = {
		ms => $wait
	};

	my $params = { action => 'wait' , options => $options };
    push @{$self->{'perform_actions'}}, $params;

    return $self->driver;
}


=method move_to ( $x, $y )

Perform a precise move_to at a certain location on the device, specified
either by pixels or percentages. All values are relative to the top
left of the device - by percentages, (0,0) would be the top left, and
(1, 1) would be the bottom right.

As per the Appium documentation, values between 0 and 1 will be
interepreted as percentages. (0.5, 0.5) will click in the center of
the screen. Values greater than 1 will be interpreted as pixels. (10,
10) will click at ten pixels away from the top and left edges of the
screen.

    # move_to in the center of the screen
    $appium->move_to( 0.5, 0.5 )->perform();

    # move_to a pixel position
    $appium->move_to( 300, 500 )->perform();

=cut

sub move_to {
	my ($self, @coords) = @_;

    my $coordinates = {
        x => $coords[0],
        y => $coords[1]
    };

	my $params = { action => 'moveTo' , options => $coordinates };
    push @{$self->{'perform_actions'}}, $params;
    return $self->driver;
}


=method release ( )

Perform a release aciton, no argument specified

    # release after any action
    $appium->release()->perform();

=cut

sub release {
	my ($self, @options) = @_;

	my $params = { action => 'release' , options => {} };
	push @{$self->{'perform_actions'}}, $params;
    return $self->driver;
}

=method long_press ( $x, $y )

Perform a precise tap at a certain location on the device, specified
either by pixels or percentages. All values are relative to the top
left of the device - by percentages, (0,0) would be the top left, and
(1, 1) would be the bottom right.

As per the Appium documentation, values between 0 and 1 will be
interepreted as percentages. (0.5, 0.5) will click in the center of
the screen. Values greater than 1 will be interpreted as pixels. (10,
10) will click at ten pixels away from the top and left edges of the
screen.

Specify the duration in miliseconds

    # long press in the center of the screen
    $appium->long_press( 0.5, 0.5, 1000 )->perform();

    # long press a pixel position
    $appium->long_press( 300, 500, 1000 )->perform();

=cut


sub long_press {
	my ($self, @params) = @_;

    my $options = {
        x => $params[0],
        y => $params[1],
		duration => $params[2]
    };

    my $final_params = { action => 'press' , options => $options };
    push @{$self->{'perform_actions'}}, $final_params;
    return $self->driver;
}


=method swipe ( $x, $y )

Perform a precise swipe at a certain location on the device, specified
start_x, start_y, wait_time,end_x,end_y


    # swipe right to left 
    $appium->swipe( 0.9, 0.5, 1000, 0.1, 0.5 )->perform();


=cut

sub swipe {
	my ($self, @coords) = @_;

	return $self->press($coords[0], $coords[1])
	  ->wait($coords[4])
	  ->move_to($coords[2], $coords[3])
	  ->release;
}

1;
