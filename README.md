# NAME

Appium - Perl bindings to the Appium mobile automation framework (WIP)

# VERSION

version 0.03

# SYNOPSIS

    my $appium = Appium->new(caps => {
        app => '/url/or/path/to/mobile/app.zip'
    });

    $appium->hide_keyboard;
    $appium->quit;

# DESCRIPTION

Appium is an open source test automation framework for use with native
and hybrid mobile apps.  It drives iOS and Android apps using the
WebDriver JSON wire protocol. This module is a thin extension of
[Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver) that adds Appium specific API endpoints
and Appium-specific constructor defaults. It's woefully incomplete at
the moment, so feel free to pitch in at the [Github
repo](https://github.com/appium/perl-client)!

For details on how Appium extends the Webdriver spec, see the Selenium
project's [spec-draft
document](https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile)

Note that like [Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver), you shouldn't have to
instantiate [Appium::Element](https://metacpan.org/pod/Appium::Element) on your own; this module will create
them when necessary so that all you need to know is what methods are
appropriate on an element vs the driver.

    my $appium = Appium->new( caps => { app => '/path/to/app.zip' } );

    # automatically instantiates Appium::Element for you
    my $elem = $appium->find_element('test', 'id');
    $elem->click;

# NEW OR UPDATED FUNCTIONALITY

### Contexts

Instead of using windows to manage switching between native
applications and webviews, use the analogous context methods:

    my $current = $appium->current_context;
    my @contexts = $appium->contexts;

    my $context = 'WEBVIEW_1'
    $appium->switch_to->context( $context );

### Finding Elements

There are different strategies available for finding elements in
Appium:

    $driver->find_element( 'ios' , 'ios' );         # iOS UIAutomation
    $driver->find_element( 'android' , 'android' ); # Android UIAutomator
    $driver->find_element( 'identifier' , 'accessibility_id' );

Note that using `id` as your finding strategy also seems to find
elements by accessibility\_id. The options for strategies are:

    id                          => 'id',
    name                        => 'name',
    xpath                       => 'xpath',
    class|class_name            => 'class name',
    accessibility_id            => 'accessibility id'
    ios|ios_uiautomation        => '-ios uiautomation',
    android|android_uiautomator => '-android uiautomator'

# METHODS

## contexts ()

Returns the contexts within the current session

    $appium->contexts;

## current\_context ()

Return the current active context for the current session

    $appium->current_context;

## switch\_to->context ( $context\_name )

Switch to the desired context for the current session

    $appium->switch_to->context( 'WEBVIEW_1' );

## hide\_keyboard( \[key\_name|key|strategy => $key\_or\_strategy\] )

Hides the software keyboard on the device. In iOS, you have the option
of using `key_name` to close the keyboard by pressing a specific
key. Or, you can specify a particular strategy; the default strategy
is `tapOutside`. In Android, no parameters are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'pressKey', key => 'Done');

## app\_strings ( \[language\] )

Get the application strings from the device for the specified
language; it will return English strings by default if the language
argument is omitted.

    $appium->app_strings
    $appium->app_strings( 'en' );

## reset ()

Reset the current application

    $appium->reset;

## press\_keycode ( keycode, \[metastate\])

Android only: send a keycode to the device. Valid keycodes can be
found in the [Android
docs](http://developer.android.com/reference/android/view/KeyEvent.html).
`metastate` describes the pressed state of key modifiers such as
META\_SHIFT\_ON or META\_ALT\_ON; more information is available in the
Android KeyEvent documentation.

    $appium->press_keycode(176);

## long\_press\_keycode ( keycode, \[metastate\])

Android only: send a long press keycode to the device. Valid keycodes
can be found in the [Android
docs](http://developer.android.com/reference/android/view/KeyEvent.html).
`metastate` describes the pressed state of key modifiers such as
META\_SHIFT\_ON or META\_ALT\_ON; more information is available in the
Android KeyEvent documentation.

    $appium->long_press_keycode(176);

## current\_activity ()

Get the current activity on the device.

    $appium->current_activity;

## pull\_file ( $file )

Pull a file from the device, returning it Base64 encoded.

    $appium->pull_file( '/tmp/file/to.pull' );

## pull\_folder ( $path )

Retrieve a folder at path, returning the folder's contents in a zip
file.

    $appium->pull_folder( 'folder' );

## push\_file ( $path, $encoded\_data )

Puts the data in the file specified by `path` on the device. The data
must be base64 encoded.

    $appium->push_file( '/file/path', $base64_data );

## complex\_find ( $selector )

Search for elements in the current application, given an array of
selection criteria.

    $appium->complex_find( $selector );

## background\_app ( $time\_in\_seconds )

Defer the application to the background on the device for the
interval, given in seconds.

    $appium->background_app( 5 );

## is\_app\_installed ( $bundle\_id )

Check whether the application with the specified `bundle_id` is
installed on the device.

    $appium->is_app_installed( $bundle_id );

## install\_app ( $app\_path )

Install the desired app on to the device

    $appium->install_app( '/path/to/local.app' );

## remove\_app( $app\_id )

Remove the specified application from the device by app ID.

    $appium->remove_app( 'app_id' );

## launch\_app ()

Start the application specified in the desired capabilities on the
device.

    $appium->launch_app;

## close\_app ()

Stop the running application, as specified in the desired
capabilities.

    $appium->close_app;

## end\_test\_coverage ( $intent, $path )

Android only: end the coverage collection and download the specified
`coverage.ec` file from the device. The file will be returned base 64
encoded.

    $appium->end_test_coverage( 'intent', '/path/to/coverage.ec' );

## lock ( $seconds )

Lock the device for a specified number of seconds.

    $appium->lock( 5 ); # lock for 5 seconds

## shake ()

Shake the device.

    $appium->shake;

## open\_notifications ()

Android only, API level 18 and above: open the notification shade on
Android.

    $appium->open_notifications;

## network\_connection ()

Android only: retrieve an integer bitmask that describes the current
network connection configuration. Possible values are listed in
["set\_network\_connection"](#set_network_connection).

    $appium->network_connection;

## set\_network\_connection ( $connection\_type\_bitmask )

Android only: set the network connection type according to the
following bitmask:

    # Value (Alias)      | Data | Wifi | Airplane Mode
    # -------------------------------------------------
    # 0 (None)           | 0    | 0    | 0
    # 1 (Airplane Mode)  | 0    | 0    | 1
    # 2 (Wifi only)      | 0    | 1    | 0
    # 4 (Data only)      | 1    | 0    | 0
    # 6 (All network on) | 1    | 1    | 0

    $appium->set_network_connection(6);

# SEE ALSO

Please see those modules/websites for more information related to this module.

- [http://appium.io](http://appium.io)
- [Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver)

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/appium/perl-client/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

# CONTRIBUTOR

Freddy Vega <freddy@vgp-miami.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
