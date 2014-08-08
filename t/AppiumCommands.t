#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use Appium;
use Test::More;
use Test::LWP::UserAgent;
use Test::MockObject::Extends;

BEGIN {
    unless (use_ok('Appium::Commands')) {
        BAIL_OUT("Couldn't load Appium::Commands");
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

my @implemented = qw/
                        contexts
                        current_context
                        hide_keyboard
                    /;

my $cmds = Appium::Commands->new->get_cmds;

foreach my $command (@implemented) {
    my ($res, undef) = $mock_appium->$command;
    ok(delete $cmds->{ $res->{command} }, $command . ' is in found in the Commands hash');
}

my @switch_to_implemented = qw/ context /;

foreach my $command (@switch_to_implemented) {
    my ($res, undef) = $mock_appium->switch_to->$command;
    ok(delete $cmds->{ $res->{command} }, $command . ' is in found in the Commands hash');
}

# There are 68 commands that we inherit from S::R::Commands. We add
# our own, and then delete them one by one in each foreach loop
# above. By the time we get here, there should only be the original 68
# left.
ok( scalar keys %{ $cmds } == 68, 'All Appium Commands are implemented!');

done_testing;
