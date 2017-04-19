#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN: {
    unless (use_ok('Appium::TouchActions')) {
        BAIL_OUT("Couldn't load Appium::TouchActions");
        exit;
    }
}

my $actions;
{
    package FakeAppium;

    use Moo;
    sub perform {
		
		my $self = shift;
		my $test = shift;
		 
		$actions = ${$test->{'perform_actions'}}[0];

		
		undef @{$test->{'perform_actions'}};

    }
}

my $fake_appium = FakeAppium->new;

my $ta = Appium::TouchActions->new(
    driver => $fake_appium
);



TOUCH_ACTIONS: {

	TAP:{

		my ($x, $y) = (0.2, 0.2);
		$ta->tap( $x, $y )->perform($ta);

		is($actions->{'action'}, 'tap', 'we perform precise taps');
		is($actions->{'options'}->{x}, $x, 'with the correct x coords');
		is($actions->{'options'}->{y}, $y, 'with the correct y coords');
	}

	PRESS:{

		my ($x, $y) = (0.2, 0.2);
        $ta->press( $x, $y )->perform($ta);

		is($actions->{'action'}, 'press', 'we perform press action');
		is($actions->{'options'}->{x}, $x, 'with the correct x coords');
        is($actions->{'options'}->{y}, $y, 'with the correct y coords');
	}

	WAIT:{

		my $wait = 1000;
		$ta->wait($wait)->perform($ta);

		is($actions->{'action'}, 'wait', 'we perform wait action');
		is($actions->{'options'}->{ms}, $wait, 'with the correct wait time');

	}

	MOVE_TO:{

		my ($x, $y) = (0.2, 0.2);
        $ta->move_to( $x, $y )->perform($ta);

		is($actions->{'action'}, 'moveTo', 'we perform move_to action');
		is($actions->{'options'}->{x}, $x, 'with the correct x coords');
        is($actions->{'options'}->{y}, $y, 'with the correct y coords');

	}

	RELEASE:{

		$ta->release()->perform($ta);
		
		is($actions->{'action'}, 'release', 'we perform release action');
	}

	LONG_PRESS:{

		my ($x, $y, $dur) = (0.2, 0.2, 1000);
        $ta->long_press( $x, $y, $dur )->perform($ta);

		is($actions->{'action'}, 'press', 'we perform press action');
		is($actions->{'options'}->{x}, $x, 'with the correct x coords');
        is($actions->{'options'}->{y}, $y, 'with the correct y coords');
        is($actions->{'options'}->{duration}, $dur, 'with the correct time');

		
	}


}

done_testing;
