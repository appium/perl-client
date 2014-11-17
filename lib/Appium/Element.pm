package Appium::Element;

# ABSTRACT: Representation of an Appium element
use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

=head1 SYNOPSIS

    my $appium = Appium->new(caps => {
        app => '/url/or/path/to/mobile/app.zip'
    });
    my $appium_element = $appium->find_element('locator', 'id');
    $appium_element->click;
    $appium_element->set_value('example', 'values');

=head1 DESCRIPTION

L<Appium::Element>s are the elements in your app with which you can
interact - you can send them taps, clicks, text for inputs, and query
them as to their state - whether they're displayed, or enabled,
etc. See L<Selenium::Remote::WebElement> for the full list of subs
that you can use on Appium elements.

=cut

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

=head1 SEE ALSO

Appium
Selenium::Remote::WebElement

=cut

1;
