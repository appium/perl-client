package Appium::Element;
$Appium::Element::VERSION = '0.0701';
# ABSTRACT: Representation of an Appium element
use Moo;
use MooX::Aliases;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';


has '+driver' => (
    is => 'ro',
    handles => [ qw/is_android is_ios/ ]
);


alias tap => 'click';


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

__END__

=pod

=encoding UTF-8

=head1 NAME

Appium::Element - Representation of an Appium element

=head1 VERSION

version 0.0701

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

=head1 METHODS

=head2 tap

Tap on the element - an alias for S::R::WebElement's 'click'

=head2 set_value ( $value )

Immediately set the value of an element in the application.

    $elem->set_value( 'immediately ', 'without waiting' );

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Appium|Appium>

=item *

L<Appium|Appium>

=item *

L<Selenium::Remote::WebElement|Selenium::Remote::WebElement>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/appium/perl-client/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Daniel Gempesaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
