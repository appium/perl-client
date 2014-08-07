#! /usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN {
    unless (use_ok('Appium'))
      {
          BAIL_OUT("Couldn't load Appium");
          exit;
      }
}



done_testing;
