#! /usr/bin/perl

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
    sub execute_script {
        my ($self, $action, $params) = @_;

        $actions->{$action} = $params;
    }
}

my $fake_appium = FakeAppium->new;

my $ta = Appium::TouchActions->new(
    driver => $fake_appium
);

TAP: {
    my ($x, $y) = (0.2, 0.2);
    $ta->tap( $x, $y );

    ok(exists $actions->{'mobile: tap'}, 'we send the correct javascript for precise taps');
    is($actions->{'mobile: tap'}->{x}, $x, 'with the correct x coords');
    is($actions->{'mobile: tap'}->{y}, $y, 'with the correct y coords');
}

FLICK: {
    $ta->scroll( 'down' );

    ok( exists $actions->{'mobile: scroll'}, 'we can scroll via mobile: scroll' );
    is( $actions->{'mobile: scroll'}->{direction}, 'down', 'with the proper direction params' );
}

done_testing;
