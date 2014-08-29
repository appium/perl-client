package Appium;

# ABSTRACT: Perl bindings to the Appium mobile automation framework (WIP)
use Moo;
use Carp qw/croak/;

use Appium::Commands;
use Appium::Element;
use Appium::ErrorHandler;
use Appium::SwitchTo;

use Selenium::Remote::Driver 0.2150;
use Selenium::Remote::RemoteConnection;
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

        return $caps;
    }
);

has '_type' => (
    is => 'rw',
    lazy => 1,
    coerce => sub {
        my $device = shift;

        croak 'platformName must be Android or iOS'
          unless grep { $_ eq $device } qw/Android iOS/;

        return $device;
    },
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

has '+remote_conn' => (
    builder => sub {
        my $self = shift;
        return Selenium::Remote::RemoteConnection->new(
            remote_server_addr => $self->remote_server_addr,
            port               => $self->port,
            ua                 => $self->ua,
            error_handler      => Appium::ErrorHandler->new
        );
    }
);

has 'webelement_class' => (
    is => 'rw',
    default => sub { 'Appium::Element' }
);

sub BUILD {
    my ($self) = @_;

    $self->_type($self->desired_capabilities->{platformName});
}

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

=method hide_keyboard( [key_name|key|strategy => $key_or_strategy] )

Hides the software keyboard on the device. In iOS, you have the option
of using C<key_name> to close the keyboard by pressing a specific
key. Or, you can specify a particular strategy; the default strategy
is C<tapOutside>. In Android, no parameters are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'pressKey', key => 'Done');

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

=method app_strings ( language )

Get the application strings from the device for the specified
language.

    $appium->app_strings;

=cut

# todo: look documentation for app strings, in particular what the
# arguments are like

sub app_strings {
    my ($self, $language) = @_;

    my $res = { command => 'app_strings' };
    my $params;
    if (defined $language ) {
        $params = { language => $language }
    }
    else {
        $params = {};
    }

    return $self->_execute_command( $res, $params );
}

=method reset ()

Reset the current application

    $appium->reset;

=cut

sub reset {
    my ($self) = @_;

    my $res = { command => 'reset' };

    return $self->_execute_command( $res );
}

=method press_keycode ( keycode, [metastate])

Android only: send a keycode to the device. Valid keycodes can be
found at in the L<Android
docs|http://developer.android.com/reference/android/view/KeyEvent.html>

    $appium->press_keycode(176);

=cut

# todo: look up what metastate is

sub press_keycode {
    my ($self, $keycode, $metastate) = @_;

    my $res = { command => 'press_keycode' };
    my $params = {
        keycode => $keycode,
    };

    $params->{metastate} = $metastate if $metastate;

    return $self->_execute_command( $res, $params );
}

=method long_press_keycode ( keycode, [metastate])

Android only: send a long press keycode to the device. Valid keycodes
can be found at in the L<Android
docs|http://developer.android.com/reference/android/view/KeyEvent.html>

    $appium->long_press_keycode(176);

=cut

# todo: look up what metastate is

sub long_press_keycode {
    my ($self, $keycode, $metastate) = @_;

    my $res = { command => 'long_press_keycode' };
    my $params = {
        keycode => $keycode,
    };

    $params->{metastate} = $metastate if $metastate;

    return $self->_execute_command( $res, $params );
}

=method current_activity ()

Get the current activity on the device.

    $appium->current_activity;

=cut

sub current_activity {
    my ($self) = @_;

    my $res = { command => 'current_activity' };

    return $self->_execute_command( $res );
}

=method pull_file ( $file )

Pull a file from the device, returning it Base64 encoded.

    $appium->pull_file( $file );

=cut

sub pull_file {
    my ($self, $path) = @_;
    croak "Please specify a path to pull from the device"
      unless defined $path;

    my $res = { command => 'pull_file' };
    my $params = { path => $path };

    return $self->_execute_command( $res, $params );
}

=method pull_folder ( $path )

Retrieve a folder at path, returning the folder's contents in a zip
file.

    $appium->pull_folder ( 'folder' );

=cut

sub pull_folder {
    my ($self, $path) = @_;
    croak 'Please specify a folder path to pull'
      unless defined $path;

    my $res = { command => 'pull_folder' };
    my $params = { path => $path };

    return $self->_execute_command( $res, $params );
}

=method push_file ( $path, $encoded_data )

Puts the data in the file specified by C<path> on the device. The data
must be base64 encoded.

    $appium->push_file ( '/file/path', $base64_data );

=cut

sub push_file {
    my ($self, $path, $data) = @_;

    my $res = { command => 'push_file' };
    my $params = {
        path => $path,
        data => $data
    };

    return $self->_execute_command( $res, $params );
}

=method complex_find ( $selector )

Search for elements in the current application, given an array of
selection criteria.

    $appium->complex_find ( $selector );

=cut

sub complex_find {
    my ($self, @selector) = @_;
    croak 'Please specify selection criteria'
      unless scalar @selector;

    my $res = { command => 'complex_find' };
    my $params = { selector => \@selector };

    return $self->_execute_command( $res, $params );
}

=method background_app ( $time_in_seconds )

Defer the application to the background on the device for the
interval, given in seconds.

    $appium->background_app ( 5 );

=cut

sub background_app {
    my ($self, $seconds) = @_;

    my $res = { command => 'background_app' };
    my $params = { seconds => $seconds};

    return $self->_execute_command( $res, $params );
}

=method is_app_installed ( $bundle_id )

Check whether the application with the specified C<bundle_id> is
installed on the device.

    $appium->is_app_installed ( $bundle_id );

=cut

sub is_app_installed {
    my ($self, $bundle_id) = @_;

    my $res = { command => 'is_app_installed' };
    my $params = { bundleId => $bundle_id };

    return $self->_execute_command( $res, $params );
}

=method install_app ( $app_path )

Install the desired app on to the device

    $appium->install_app ( '/path/to/local.app' );

=cut

sub install_app {
    my ($self, $app_path) = @_;

    my $res = { command => 'install_app' };
    my $params = { appPath => $app_path };

    return $self->_execute_command( $res, $params );
}

=method remove_app ( $app_id )

Remove the specified application from the device by app ID.

    $appium->remove_app ( 'app_id' );

=cut

sub remove_app {
    my ($self, $app_id) = @_;

    my $res = { command => 'remove_app' };
    my $params = { appId => $app_id };

    return $self->_execute_command( $res, $params );
}

=method launch_app ()

Start the application specified in the desired capabilities on the
device.

    $appium->launch_app;

=cut

sub launch_app {
    my ($self) = @_;

    my $res = { command => 'launch_app' };
    return $self->_execute_command( $res );
}

=method close_app ()

Stop the running application, as specified in the desired
capabilities.

    $appium->close_app;

=cut

sub close_app {
    my ($self) = @_;

    my $res = { command => 'close_app' };
    return $self->_execute_command( $res );
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
