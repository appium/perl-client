#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use Test::More;
use Appium::Element;
use Cwd qw/abs_path/;

BEGIN: {
    my $test_lib = abs_path(__FILE__);
    $test_lib =~ s/(.*)\/.*\.t$/$1\/lib/;
    push @INC, $test_lib;
    require MockAppium;

    unless (use_ok('Appium::Commands')) {
        BAIL_OUT("Couldn't load Appium::Commands");
        exit;
    }
}


my $mock_appium = MockAppium->new;

my @implemented = qw/
                        app_strings
                        contexts
                        current_context
                        hide_keyboard
                        reset
                    /;

my $cmds = Appium::Commands->new->get_cmds;

DRIVER_COMMANDS: {
    foreach my $command (@implemented) {
        ok($mock_appium->can($command), 'Appium can ' . $command);

        my ($res, undef) = $mock_appium->$command;
        delete $cmds->{ $res->{command} };
    }
}

SWITCH_TO_COMMANDS: {
    my @switch_to_implemented = qw/ context /;

    foreach my $command (@switch_to_implemented) {
        ok($mock_appium->switch_to->can($command), 'SwitchTo can ' . $command);

        my ($res) = $mock_appium->switch_to->$command;
        delete $cmds->{ $res->{command} };
    }
}

ELEMENT_COMMANDS: {
    $mock_appium->_type('Android');
    my $elem = Appium::Element->new(
        id => 0,
        driver => $mock_appium
    );

    my @element_implemented = qw/ set_text /;
    foreach my $command (@element_implemented) {
        ok($elem->can($command), 'Elem can ' . $command);

        my ($res) = $elem->$command('');
        delete $cmds->{ $res->{command} };
    }

}

# There are 70 commands that we inherit from S::R::Commands. We add
# our own, and then delete them one by one in each foreach loop
# above. By the time we get here, there should only be the original 70
# left.
my $SRD_COMMANDS = 70;
cmp_ok( scalar keys %{ $cmds }, '==', $SRD_COMMANDS, 'All Appium Commands are implemented!');

done_testing;
