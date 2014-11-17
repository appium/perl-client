package Appium::Element;

# ABSTRACT: Representation of an Appium element
use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

has '+driver' => (
    handles => [ qw/is_android is_ios/ ]
);

=method set_value ( $value )

Immediately set the value of an element in the application.

    $elem->set_value( 'immediately ', 'without waiting' );

=cut

sub set_value {
    my ($self, @values) = @_;
    croak "Please specify a value to set" unless scalar @values;

    my $res = { command => 'set_value' };
    my $params = {
        id => $self->id,
        value => \@values
    };

    return $self->_execute_command( $res, $params );
}

1;
