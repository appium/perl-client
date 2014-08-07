package Appium::Commands;
use Moo;
extends 'Selenium::Remote::Commands';

has 'get_cmds' => (
    is => 'lazy',
    builder => sub {
        my ($self) = @_;
        my $commands = $self->SUPER::get_cmds;;
        my $appium_commands = {
            hideKeyboard => {
                method => 'POST',
                url => 'session/:sessionId/appium/device/hide_keyboard',
                no_content_success => 1
            }
        };

        foreach (keys %$appium_commands) {
            $commands->{$_} = $appium_commands->{$_};
        }

        return $commands;
    }
);

1;
