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

my $mock_appium = MockAppium->new;
my $elem = Appium::Element->new(
    id => 0,
    driver => $mock_appium
);

SET_TEXT: {
  ANDROID: {
        $mock_appium->_type('Android');
        my ($res, $params) = $elem->set_text( qw/a b c d e f g/ );
        ok(join('', @{ $params->{value} }) eq 'abcdefg', 'can set android text');
    }

  IOS: {
        $mock_appium->_type('iOS');
        my @res = $elem->set_text( qw/a b c d e f g/ );

        # This gets a little ugly because the ios version of set text
        # ends in S::R::D's invoking _execute_command by itself, and
        # in their code, they ask for a scalar instead of a list - ie,
        #
        # my $ret =  $d->_execute_command,
        #
        # instead of the way we've been doing it in the Appium
        # library:
        #
        # my ($res, $params) = $d->_execute_command.
        #
        # So, there's an extra level of dereferencing that we have to
        # do, and we also have to use wantarray in the MockAppium
        # library.
        my $script = $res[0]->[1]->{script};
        ok($script eq 'au.getElement("0").setValue("abcdefg");', 'can set ios text!');
    }
}


done_testing;
