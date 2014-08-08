# NAME

Appium - Perl bindings to the Appium mobile automation framework (WIP)

# VERSION

version 0.02

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
Selenium::Remote::Driver that adds Appium specific API endpoints and
Appium-specific constructor defaults.

It is woefully incomplete at the moment. Feel free to pitch in!

# METHODS

## hide\_keyboard( key\_name|key|strategy => $key\_or\_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using \`key\_name\` to close the keyboard by pressing a specific
key. Or, you can use a particular strategy. In Android, no parameters
are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside');

# SEE ALSO

http://appium.io
Selenium::Remote::Driver

# AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
