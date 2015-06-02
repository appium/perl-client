package Appium::Android::CanPage;

# ABSTRACT: Display all interesting elements for Android, useful during authoring
use Moo::Role;
use feature qw/state/;
use XML::LibXML;

sub page {
    my ($self) = @_;

    my $source = $self->get_page_source;
    my $parser = XML::LibXML->new;
    my $dom = $parser->load_xml( string => $source );
    my @nodes = $dom->childNodes;

    return $self->_inspect_nodes( @nodes );
}

sub _inspect_nodes {
    my ($self, @nodes) = @_;

    state $interesting_attrs = [ qw/text resource-id content-desc/ ];
    state $indent = '  ';

    use feature qw/say/;
    foreach my $node (@nodes) {
        my $is_node_interesting = 0;
        foreach my $attr (@$interesting_attrs) {
            if ( $node->hasAttribute( $attr ) && $node->getAttribute( $attr ) ne '' ) {
                $is_node_interesting++;
            }
        }

        if ( $is_node_interesting ) {
            say $node->getAttribute('class');
            foreach (@$interesting_attrs) {
                my $value = $node->getAttribute( $_ );
                say $indent . $_ . ': ' . $value  if $value ne '';
            }
            say '';
        }


        $self->_inspect_nodes( $node->childNodes );
    }
}

1;
