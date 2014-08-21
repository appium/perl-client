package Appium::Element;

use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

sub set_text {
    my ($self, @keys) = @_;
    croak "set_text requires text to set" unless scalar @keys >= 1;

    my $res = {
        id => $self->id,
        command => 'set_text'
    };

    my $params = {
        value => \@keys
    };

    return $self->_execute_command($res, $params);
}

1;
