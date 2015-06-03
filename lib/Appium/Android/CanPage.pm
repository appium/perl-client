package Appium::Android::CanPage;

# ABSTRACT: Display all interesting elements for Android, useful during authoring
use Moo::Role;
use XML::LibXML;

has _page_printer => (
    is => 'lazy',
    default => sub { return sub { print shift . "\n"; } }
);

has _page_parser => (
    is => 'lazy',
    default => sub { return XML::LibXML->new; }
);


sub page {
    my ($self) = @_;

    my $source = $self->get_page_source;
    my $parser = $self->_page_parser;
    my $dom = $parser->load_xml( string => $source );
    my @nodes = $dom->childNodes;

    return $self->_inspect_nodes( @nodes );
}

sub _inspect_nodes {
    my ($self, @nodes) = @_;

    # A node is interesting if it has a text, id, or content-desc
    # attribute.
    my $interesting_attrs = [ qw/text resource-id content-desc/ ];

    foreach my $node (@nodes) {
        # The inspect output for a single node looks like:
        #
        # $class_of_node
        #    text: $node_text
        #    resource-id: $node_id
        #    content-desc: $node_desc
        #
        # We'll keep the lines in an array that we push on to whenever
        # we find interesting things about the node
        my @inspect_output = ( $node->getAttribute('class') );

        my $is_node_interesting = 0;
        foreach my $attr (@$interesting_attrs) {
            if ( $node->hasAttribute( $attr ) ) {
                my $value = $node->getAttribute( $attr );

                # We don't want to display attributes that are empty.
                if ( $value ) {
                    $is_node_interesting++;
                    push @inspect_output, _format_attribute( $attr, $value );
                }
            }
        }

        if ( $is_node_interesting ) {
            # Separate entire nodes with an extra new line
            push @inspect_output, '';
            $self->_page_printer->( join( "\n", @inspect_output ) );
        }

        $self->_inspect_nodes( $node->childNodes );
    }
}

sub _format_attribute {
    my ($name, $value) = @_;

    return "  $name: $value";
}

1;
