package Appium;
$Appium::VERSION = '0.01';
# ABSTRACT: Perl bindings to the Appium mobile automation framework (WIP)
use Moo;
use Carp qw/croak/;
use Appium::Commands;
extends 'Selenium::Remote::Driver';



has '+desired_capabilities' => (
    is => 'rw',
    required => 1,
    init_arg => 'caps',
    coerce => sub {
        my $caps = shift;
        croak 'Desired capabilities must include: app' unless exists $caps->{app};

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

has '+port' => (
    is => 'rw',
    default => sub { 4723 }
);

has '+commands' => (
    is => 'ro',
    default => sub { Appium::Commands->new }
);


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

__END__

=pod

=encoding UTF-8

=head1 NAME

Appium - Perl bindings to the Appium mobile automation framework (WIP)

=head1 VERSION

version 0.01

=head1 SYNOPSIS

my $appium = Appium->new(caps => {
    app => '/url/or/path/to/mobile/app.zip'
});

$appium->hide_keyboard;
$appium->quit;

=head1 DESCRIPTION

Appium is an open source test automation framework for use with native
and hybrid mobile apps.  It drives iOS and Android apps using the
WebDriver JSON wire protocol. This module is a thin extension of
Selenium::Remote::Driver that adds Appium specific API endpoints and
Appium-specific constructor defaults.

It is woefully incomplete at the moment. Feel free to pitch in!

=head1 METHODS

=head2 hide_keyboard( key_name|key|strategy => $key_or_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using `key_name` to close the keyboard by pressing a specific
key. Or, you can use a particular strategy. In Android, no parameters
are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside');

=head1 SEE ALSO

http://appium.io
Selenium::Remote::Driver

=head1 AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
