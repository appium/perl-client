use strict;
use warnings;
package Appium;

# ABSTRACT: Perl bindings to the Appium mobile automation framework

package Appium;
use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::Driver';

has '+desired_capabilities' => (
    is => 'rw',
    required => 1,
    coerce => sub {
        my $caps = shift;
        croak 'Desired Capabilities must include: app' unless exists $caps->{app};

        my $defaults = {
            browserName => '',
            deviceName => 'iPhone Simulator',
            platformName => 'iOS',
            platformVersion => '7.1'
        };

        foreach (keys %$defaults) {
            unless (exists $caps->{$_}) {
                $caps->{$_} = $defaults->{$_};
            }
        }

        return $caps;
    }
);

has 'port' => (
    is => 'rw',
    default => sub { 4723 }
);

has 'commands' => (
    is => 'ro',
    default => sub { Appium::Commands->new }
);
1;
