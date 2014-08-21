package Appium;

# ABSTRACT: Perl bindings to the Appium mobile automation framework (WIP)
use Moo;
use Carp qw/croak/;

use Appium::SwitchTo;
use Appium::Commands;
extends 'Selenium::Remote::Driver';


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

=cut

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

=cut

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

        croak 'platformName must be Android or iOS'
          unless grep { $_ eq $caps->{platformName} } qw/Android iOS/;
        $self->_type($caps->{platformName});

        return $caps;
    }
);

has '_type' => (
    is => 'rw',
    lazy => 1,
    default => sub { 'iOS' }
);


has '+port' => (
    is => 'rw',
    default => sub { 4723 }
);

has '+commands' => (
    is => 'ro',
    default => sub { Appium::Commands->new }
);

has 'webelement_class' => (
    is => 'rw',
    default => sub { 'Appium::Element' }
);

=method contexts ()

Returns the contexts within the current session

    $appium->contexts;

=cut

sub contexts {
    my ($self) = @_;

    my $res = { command => 'contexts' };
    return $self->_execute_command( $res );
}

=method current_context ()

Return the current active context for the current session

    $appium->current_context;

=cut

sub current_context {
    my ($self) = @_;

    my $res = { command => 'get_current_context' };
    my $params = {};

    return $self->_execute_command( $res, $params );
}

=method switch_to->context ( $context_name )

Switch to the desired context for the current session

    $appium->switch_to->context( 'WEBVIEW_1' );

=cut

has 'switch_to' => (
    is => 'lazy',
    init_arg => undef,
    default => sub { Appium::SwitchTo->new( driver => shift );  }
);


=method hide_keyboard( key_name|key|strategy => $key_or_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using C<key_name> to close the keyboard by pressing a specific
key. Or, you can specify a particular strategy; the default strategy
is C<tapOutside>. In Android, no parameters are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside', key => 'Done');

=cut

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

sub is_android {
    return shift->_type eq 'Android'
}

sub is_ios {
    return shift->_type eq 'iOS'
}

=head1 SEE ALSO

http://appium.io
Selenium::Remote::Driver

=cut

1;
