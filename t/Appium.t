#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use Test::More;
use Test::Deep;
use Cwd qw/abs_path/;
use Appium::Commands;

BEGIN: {
    my $test_lib = abs_path(__FILE__);
    $test_lib =~ s/(.*)\/.*\.t$/$1\/lib/;
    push @INC, $test_lib;
    require MockAppium;

    unless (use_ok('Appium')) {
        BAIL_OUT("Couldn't load Appium");
        exit;
    }
}

my $mock_appium = MockAppium->new;
my @aliases = keys %{ Appium::Commands->new->get_cmds };

CONTEXT: {
    my $context = 'WEBVIEW_1';
    my ($res, $params) = $mock_appium->switch_to->context( $context );
    alias_ok('switch_to->context', $res);
    cmp_ok($params->{name}, 'eq', $context, 'can switch to a context');
}

HIDE_KEYBOARD: {
    my $tests = [
        {
            args => [],
            expected => {
                test => 'no args passes default strategy',
                key => 'strategy',
                value => 'tapOutside'
            }
        },
        {
            args => [ key_name => 'Done' ],
            expected => {
                test => 'can pass a key_name',
                key => 'keyName',
                value => 'Done'
            }
        },
        {
            args => [ strategy => 'fake strategy', key => 'Done' ],
            expected => {
                test => 'can pass a strategy',
                key => 'strategy',
                value => 'fake strategy'
            }
        }
    ];

    foreach (@$tests) {
        my $expected = $_->{expected};
        my (undef, $params) = $mock_appium->hide_keyboard(@{ $_->{args} });

        my $key = $expected->{key};
        ok( exists $params->{$key}, 'hide_keyboard, key: ' . $expected->{test});
        cmp_ok( $params->{$key}, 'eq', $expected->{value}, 'hide_keyboard, val: ' . $expected->{test});

        if ($expected->{test} eq 'can pass a strategy') {
            ok( exists $params->{key}, 'hide_keyboard, key: strategy and key are included');
            cmp_ok( $params->{key}, 'eq', 'Done', 'hide_keyboard, val: strategy and key are included');

        }
    }
}

ANDROID_KEYCODES: {
    my $code = 176;
    check_endpoint('press_keycode', [ $code ], { keycode => $code });
    check_endpoint('long_press_keycode', [ $code, 'metastate' ], { keycode => $code, metastate => 'metastate' });

}

PUSH_PULL: {
    my $path = '/fake/path';
    my $data = 'pretend to be base 64 encoded';
    check_endpoint('pull_file', [ $path ], { path => $path });
    check_endpoint('pull_folder', [ $path ], { path => $path });
    check_endpoint('push_file', [ $path, $data ], { path => $path, data => $data });
}

FIND: {
    my @selector = qw/fake selection critera/;
    check_endpoint('complex_find', [ @selector ], { selector => \@selector });
}

APP: {
    check_endpoint('background_app', [ 5 ], { seconds => 5 });
    check_endpoint('is_app_installed', [ 'a fake bundle id' ], { bundleId => 'a fake bundle id' });
    check_endpoint('install_app', [ '/fake/path/to.app' ], { appPath => '/fake/path/to.app' });
    check_endpoint('remove_app', [ '/fake/path/to.app' ], { appId => '/fake/path/to.app' });
    check_endpoint('launch_app', [], undef );
    check_endpoint('close_app', [], undef );
}

MISC: {
    check_endpoint('end_test_coverage', [ 'intent', 'path' ], {
        intent => 'intent',
        path => 'path'
    });

}


sub check_endpoint {
    my ($endpoint, $args, $expected) = @_;

    my ($res, $params) = $mock_appium->$endpoint(@{ $args });

    # check it's in the commands hash
    alias_ok($endpoint, $res);

    # validate the args get processed as expected
    cmp_deeply($params, $expected, $endpoint . ': params are properly organized');
}

sub alias_ok {
    my ($endpoint, $res) = @_;
    my @alias_found = grep { $_ eq $res->{command} } @aliases;
    return ok(@alias_found, $endpoint . ': has a valid endpoint alias');
}



done_testing;
