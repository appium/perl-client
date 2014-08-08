package Appium::SwitchTo;
use Moo;

has 'driver' => (
    is => 'ro',
    required => 1,
    handles => [qw/_execute_command/]
);

=method context ( $context_name )

Set the context for the current session.

    $appium->switch_to->context( 'WEBVIEW_1' );

=cut

sub context {
    my ($self, $context_name ) = @_;

    my $res = { command => 'switch_to_context' };
    my $params = { name => $context_name };

    return $self->_execute_command( $res, $params );
}

1;
