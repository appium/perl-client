#! /usr/bin/perl

use strict;
use warnings;
use Test::More;
use Cwd qw/abs_path/;

BEGIN: {
    my $test_lib = abs_path(__FILE__);
    $test_lib =~ s/(.*)\/.*\.t$/$1\/lib/;
    push @INC, $test_lib;
    require MockAppium;

    unless (use_ok('Appium::Element')) {
        BAIL_OUT("Couldn't load Appium::Element");
        exit;
    }
}

my $mock = MockAppium->new;
my $elem = Appium::Element->new(
    id => 0,
    driver => $mock
);

SET_TEXT: {
    my ($res, $params) = $elem->set_text( qw/a b c d e f g/ );
    ok(join('', @{ $params->{value} }) eq 'abcdefg', 'can set text');
}

SET_TEXT_IOS: {
    my (@res) = $elem->set_text_ios( qw/a b c d e f g/ );
    my $script = $res[0]->[1]->{script};
    ok($script eq 'au.getElement("0").setValue("abcdefg");', 'can set ios text!');
}


done_testing;
