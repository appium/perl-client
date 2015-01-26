package Appium::Element;

# ABSTRACT: Representation of an Appium element
use Moo;
use MooX::Aliases;
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
etc. See L<Selenium::Remote::WebElement> for the full descriptions of
the following subroutines that we inherit:

    click
    submit
    send_keys
    is_selected
    set_selected
    toggle
    is_enabled
    get_element_location
    get_element_location_in_view
    get_tag_name
    clear
    get_attribute
    get_value
    is_displayed
    is_hidden
    get_size
    get_text

Although we blindly inherit all of these subs, there's no guarantee
that they will work in Appium. For example, we inherit
L<Selenium::Remote::WebElement/describe>, but Appium doesn't implement
C<describe>, so it won't do anything in this sub.

=cut

has '+driver' => (
    is => 'ro',
    handles => [ qw/is_android is_ios/ ]
);

=method tap

Tap on the element - an alias for S::R::WebElement's 'click'

=cut

alias tap => 'click';

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
