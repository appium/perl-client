# NAME

Appium - Perl bindings to the Appium mobile automation framework

# VERSION

version 0.01

# METHODS

## hide\_keyboard( key\_name|key|strategy => $key\_or\_strategy )

Hides the software keyboard on the device. In iOS, you have the option
of using \`key\_name\` to close the keyboard by pressing a specific
key. Or, you can use a particular strategy. In Android, no parameters
are used.

    $appium->hide_keyboard;
    $appium->hide_keyboard( key_name => 'Done');
    $appium->hide_keyboard( strategy => 'tapOutside');

# AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
