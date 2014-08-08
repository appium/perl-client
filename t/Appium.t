#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use Test::More;
use Cwd qw/abs_path/;

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

CONTEXT: {
    my $context = 'WEBVIEW_1';
    my (undef, $params) = $mock_appium->switch_to->context( $context );
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

done_testing;
