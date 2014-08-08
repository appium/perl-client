package MockAppium;

use strict;
use warnings;
use JSON;
use Appium;
use Test::LWP::UserAgent;
use Test::MockObject::Extends;

sub new {
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

    return $mock_appium;

}

1;
