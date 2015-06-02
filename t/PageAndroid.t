use strict;
use warnings;

use Appium;
use Cwd qw/abs_path/;
use Capture::Tiny qw/capture_stdout/;
use File::Basename qw/dirname/;
use IO::Socket::INET;
use IPC::Cmd qw/can_run/;
use Test::Spec;

plan skip_all => "Release tests not required for installation."
  unless $ENV{RELEASE_TESTING};

my $has_appium_server = IO::Socket::INET->new(
    PeerAddr => 'localhost',
    PeerPort => 4723,
    Timeout => 2
);
plan skip_all => "No Appium server found" unless $has_appium_server;
plan skip_all => 'No adb found' unless can_run('adb');

my $devices = `adb devices`;
my $is_device_available = $devices =~ /device$|emulator/m;
plan skip_all => 'No running android devices found: ' . $devices
  unless $is_device_available;

describe 'Android Page command' => sub {
    # eval
        my ($appium) = Appium->new( caps => {
            app => dirname(abs_path(__FILE__)) . '/fixture/ApiDemos-debug.apk',
            deviceName => 'Android Emulator',
            platformName => 'Android',
            platformVersion => '4.4.4'
        });

    it 'should print out the elements' => sub {
        my $page = capture_stdout { $appium->page };
        ok( $page );
    };
};


runtests;
