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
		
		my ($self, $params ) = @_;
		my $actions = $self->{'touch_actions'}->{'perform_actions'};

    }
}

my $fake_appium = FakeAppium->new;

my $ta = Appium::TouchActions->new(
    driver => $fake_appium
);

TOUCH_ACTIONS: {
    my ($x, $y) = (0.2, 0.2);
    $ta->tap( $x, $y )->perform();

    ok(exists $actions->{'action'}->{'tap'}, 'we perform precise taps');
    is($actions->{'options'}->{x}, $x, 'with the correct x coords');
    is($actions->{'options'}->{y}, $y, 'with the correct y coords');

}

done_testing;
