package Appium::Commands;

# ABSTRACT: Appium specific extensions to the Webdriver JSON protocol
use Moo;
extends 'Selenium::Remote::Commands';

=head1 DESCRIPTION

There's not much to see here. View the source if you'd like to see the
Appium specific endpoints. Otherwise, you might be looking for
L<Appium> or L<Selenium::Remote::Commands>.

=cut

has 'get_cmds' => (
    is => 'lazy',
    builder => sub {
        my ($self) = @_;
        my $commands = $self->SUPER::get_cmds;

        my $appium_commands = {
            contexts => {
                method => 'GET',
                url => '/session/$sessionId/contexts',
                no_content_success => 0
            },
            get_current_context => {
                method => 'GET',
                url => '/session/$sessionId/context',
                no_content_success => 0
            },
            switch_to_context => {
                method => 'POST',
                url => '/session/$sessionId/context',
                no_content_success => 1
            },
            hide_keyboard => {
                method => 'POST',
                url => '/session/$sessionId/appium/device/hide_keyboard',
                no_content_success => 1
            },
        };

        foreach (keys %$appium_commands) {
            $commands->{$_} = $appium_commands->{$_};
        }

        return $commands;
    }
);

=head1 SEE ALSO

Selenium::Remote::Commands

=cut

1;
