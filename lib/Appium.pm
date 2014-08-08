package Appium;
$Appium::VERSION = '0.02';
# ABSTRACT: Perl bindings to the Appium mobile automation framework (WIP)
use Moo;
use Carp qw/croak/;

use Appium::SwitchTo;
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


sub contexts {
    my ($self) = @_;

    my $res = { command => 'contexts' };
    return $self->_execute_command( $res );
}


sub current_context {
    my ($self) = @_;

    my $res = { command => 'get_current_context' };
    my $params = {};

    return $self->_execute_command( $res, $params );
}


has 'switch_to' => (
    is => 'lazy',
    init_arg => undef,
    default => sub { Appium::SwitchTo->new( driver => shift );  }
);



sub hide_keyboard {
    my ($self, %args) = @_;

    my $res = { command => 'hide_keyboard' };
    my $params = {};

    if (exists $args{key_name}) {
        $params->{keyName} = $args{key_name}
    }
    elsif (exists $args{key}) {
        $params->{key} = $args{key}
    }

    # default strategy is tapOutside
    my $strategy = 'tapOutside';
    $params->{strategy} = $args{strategy} || $strategy;

    return $self->_execute_command( $res, $params );
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Appium - Perl bindings to the Appium mobile automation framework (WIP)

=head1 VERSION

version 0.02

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
L<Selenium::Remote::Driver> that adds Appium specific API endpoints and
Appium-specific constructor defaults.

For details on how Appium extends the Webdriver spec, see the Selenium
project's L<spec-draft
document|https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile>

This module is woefully incomplete at the moment. Feel free to pitch in!

=head1 NEW OR UPDATED FUNCTIONALITY

=head3 Contexts

Instead of using windows to manage switching between native
applications and webviews, use the analogous context methods:

    my $current = $appium->current_context;
    my @contexts = $appium->contexts;

    my $context = 'WEBVIEW_1'
    $appium->switch_to->context( $context );

Note that this module uses the C<< ->switch_to->context >> syntax, unlike
its parent module.

=head1 METHODS

=head2 contexts ()

Returns the contexts within the current session

    $appium->contexts;

=head2 current_context ()

Return the current active context for the current session

    $appium->current_context;

=head2 switch_to->context ( $context_name )

Switch to the desired context for the current session

    $appium->switch_to->context( 'WEBVIEW_1' );

=head2 hide_keyboard( key_name|key|strategy => $key_or_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using C<key_name> to close the keyboard by pressing a specific
key. Or, you can specify a particular strategy; the default strategy
is C<tapOutside>. In Android, no parameters are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside', key => 'Done');

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<http://appium.io|http://appium.io>

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/Appium-Perl-Client/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
