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

=method hide_keyboard( key_name|key|strategy => $key_or_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using `key_name` to close the keyboard by pressing a specific
key. Or, you can use a particular strategy. In Android, no parameters
are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside');

=cut

sub hide_keyboard {
    my ($self, @args) = @_;

    my $res = { command => 'hideKeyboard' };
    my $params = {};

    if (scalar @args == 2) {
        foreach (qw/key_name key strategy/) {
            if ($args[0] eq $_) {
                my $key = $_;
                $key = 'keyName' if $_ eq 'key_name';

                $params->{$key} = $args[1];
                last;
            }
        }
    }
    else {
        $params->{strategy} = 'tapOutside';
    }

    return $self->_execute_command( $res, $params );
}

1;
