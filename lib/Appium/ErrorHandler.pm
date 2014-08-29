package Appium::ErrorHandler;

# ABSTRACT: Reformat the error messages for user consumption
use Moo;
extends 'Selenium::Remote::ErrorHandler';

sub process_error {
    my ($self, $resp) = @_;
    my $value = $resp->{value};

    return {
        stackTrace => $value->{stackTrace},
        error => $self->STATUS_CODE->{$resp->{status}},
        message => $value->{origValue} || $value->{message}
    };
}


1;
