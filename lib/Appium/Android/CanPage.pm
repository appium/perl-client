package Appium::Android::CanPage;

# ABSTRACT: Display all interesting elements for Android, useful during authoring
use Moo::Role;
use XML::Simple;

sub page {
    return shift->_inspect_page;

}

sub _inspect_page {
    my ($self) = @_;

    my $source = $self->get_page_source;
    my $page = XMLin( $source );
    use Data::Dumper; use DDP;
    p $page;

}

1;
