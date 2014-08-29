package Appium::Element;

use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

has '+driver' => (
    handles => [ qw/is_android is_ios/ ]
);

=method set_text ( $text )

Set the value of an element, replacing any already existing text. Use
this method for overwriting Android hint text in textfields.

    $elem->set_text( 'clear existing text' );

=cut

sub set_text {
    my ($self, @keys) = @_;
    croak "set_text requires text to set" unless scalar @keys >= 1;

    if ($self->is_android) {
        $self->set_text_android(@keys);
    }
    elsif ($self->is_ios) {
        return $self->set_text_ios(@keys);
    }
}

sub set_text_android {
    my ($self, @keys) = @_;

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
