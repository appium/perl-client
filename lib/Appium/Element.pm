package Appium::Element;
$Appium::Element::VERSION = '0.04';
# ABSTRACT: Representation of an Appium element
use Moo;
use Carp qw/croak/;
extends 'Selenium::Remote::WebElement';

has '+driver' => (
    handles => [ qw/is_android is_ios/ ]
);


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

version 0.04

=head1 METHODS

=head2 set_text ( $text )

Set the value of an element, replacing any already existing text. Use
this method for overwriting Android hint text in textfields.

    $elem->set_text( 'clear existing text' );

=head2 set_value ( $value )

Immediately set the value of an element in the application.

    $elem->set_value( 'immediately ', 'without waiting' );

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Appium|Appium>

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
