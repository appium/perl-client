package Appium::Commands;
$Appium::Commands::VERSION = '0.01';
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

__END__

=pod

=encoding UTF-8

=head1 NAME

Appium::Commands

=head1 VERSION

version 0.01

=head1 AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
