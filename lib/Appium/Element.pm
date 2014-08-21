package Appium::Element;

use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

has '+driver' => (
    handles => [ qw/is_android is_ios/ ]
);

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

sub set_text_ios {
    my ($self, @keys) = @_;
    croak "set_text_ios requires text to set" unless scalar @keys >= 1;

    my $keys = join('', @keys);
    return $self->driver->execute_script('au.getElement("' . $self->id . '").setValue("' . $keys . '");');
}

1;
