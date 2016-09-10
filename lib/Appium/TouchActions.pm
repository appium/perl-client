package Appium::TouchActions;

# ABSTRACT: Perform touch actions through appium: taps, swipes, scrolling
use Moo;
use Scalar::Util qw/blessed/;

has 'driver' => (
    is => 'ro',
    required => 1
);

has 'actions' => (
	is => 'lazy',
	default => sub { [] },
	clearer => 1
);

=head1 SYNOPSIS

    my $appium = Appium->new;
    my $elem = Appium->find_element('tap_me', 'id');

    my $ta = TouchActions->new(driver => $appium);
    $ta->tap($elem, 10, 10);
    $ta->press(50, 50)
      ->move_to(50, 50)
      ->release;
    $ta->perform; # taps $elem at (10, 10) from its top let corner, then
                  # presses at (50, 50), slides to (100, 100), and
                  # releases.

=head1 DESCRIPTION

The TouchActions class is used for performing more complicated actions
on a mobile device. This class must be constructed separately from the
Appium driver class itself, and it takes the driver as an argument
during construction.

When constructing a TouchAction chain, none of the actions are
evaluated until you call L</perform>.

The majority of the methods in this class take at least four optional
arguments, in this specific order: C<[element], [x_coord], [y_coord],
[duration]>.

=for :list

* element (optional) - if specified, this must be an
  Appium::WebElement, and it must be the first item in the list

* x, y (optional) - accepts values in pixels. if either of (x, y) is
  specified, the other must be as well. It doesn't make sense to only
  specify one of the two. If C<element> is also specified, the
  location will be relative to the top left corner of the specified
  element. If C<element> is not specified, the location will be
  relative to the top left corner of the entire device

* duration (optional) - some subroutines accept an millisecond amount
  of time to perform the action. For example, the different between
  L</press> and L</long_press> is the duration of time specified.

=method tap ( [$element], [$x, $y] )

Perform a tap at a certain location on the device. The arguments are
C<[$element], [$x], $[y]>; duration is not an option here. For a tap
with duration, see L</long_press>.

=cut

sub tap {
    my ($self, @args) = @_;

	my $options = $self->_parse_opts(@args);
	$self->_add_action('tap', $options);
    return $self;
}

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

sub _add_action {
	my ($self, $action, $options) = @_;

	my $gesture = {
		action => $action,
		options => $options
	};

	$self->actions(push($self->actions, $gesture));
}

=pod _parse_opts

The TouchAction methods all take optional arguments in the following
order: C<element, x_coord, y_coord, duration>. Since all of the
options are optional, there is some finagling to do to construct the
proper <opts> argument that Appium expects.

=cut

sub _parse_opts {
	my ($self) = shift;
	my $opts = {};

	my $element = shift || undef;
	if (blessed($element) && $element->isa('Appium::WebElement')) {
		$opts->{element} = $element->id;
	}

	my $x = shift || undef;
	my $y = shift || undef;
	if ($x == undef or $y == undef) {
		# It doesn't make sense to specify only an $x, or only a $y.
		($x, $y) = (undef, undef);
	}
	$opts->{x} = $x;
	$opts->{y} = $y;

	my $duration = shift || undef;
	if ($duration != undef) {
		$opts->{duration} = $duration;
	}

	return $opts;
}

1;
