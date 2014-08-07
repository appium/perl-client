#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use Test::More;
use Test::LWP::UserAgent;
use Test::MockObject::Extends;

BEGIN: {
    unless (use_ok('Appium')) {
        BAIL_OUT("Couldn't load Appium");
        exit;
    }
}

my $tua = Test::LWP::UserAgent->new;
my $fake_session_response = {
    cmd_return => {},
    cmd_status => 'OK',
    sessionId => '123124123'
};

$tua->map_response(qr{status}, HTTP::Response->new(200, 'OK'));
$tua->map_response(qr{session}, HTTP::Response->new(204, 'OK', ['Content-Type' => 'application/json'], to_json($fake_session_response)));

my $appium = Appium->new(
    caps => { app => 'fake' },
    ua => $tua
);

my $mock_appium = Test::MockObject::Extends->new($appium);

$mock_appium->mock('_execute_command', sub { shift; @_;});

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
            args => [ strategy => 'fake strategy' ],
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
    }
}

done_testing;
