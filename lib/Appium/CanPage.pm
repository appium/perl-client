package Appium::CanPage;

# ABSTRACT: Display all interactable elements, useful during test authoring
use Moo::Role;
use feature qw/state/;

requires 'is_android';
requires 'is_ios';

=method page

A shadow of L<arc|https://github.com/appium/ruby_console>'s page
command, this will print to STDOUT a list of all the visible elements
on the page along with whatever details are available (name, label,
value, etc). It's currently only compatible with iOS, and it doesn't
take filtering arguments like arc's version of page does.

    $appium->page;
    # UIAWindow
    #   UIATextField
    #     name          : IntegerA
    #     label         : TextField1
    #     value         : 5
    #     UIATextField
    #       name        : TextField1
    #       label       : TextField1
    #       value       : 5
    #   UIATextField
    #     name          : IntegerB
    #     label         : TextField2
    #     UIATextField
    #       name        : TextField2
    #       label       : TextField2
    # ...

=cut

sub page {
    my ($self) = @_;

    $self->_get_page;
}

sub _get_page {
    my ($self, $element, $level) = @_;
    return 'TODO: implement page on android' if $self->is_android;

    $element //= $self->_source_window_with_children;
    $level //= 0;
    my $indent = '  ' x $level;

    # App strings are found in an actual file in the app package
    # somewhere, so I'm assuming we don't have to worry about them
    # changing in the middle of our app execution. This may very well
    # turn out to be a false assumption.
    state $strings = $self->app_strings;

    my @details = qw/name label value hint/;
    if ($element->{visible}) {
        print $indent .  $element->{type} . "\n";
        foreach (@details) {
            my $detail = $element->{$_};
            if ($detail) {
                print $indent .  '  ' . $_ . "\t: " . $detail  . "\n" ;

                foreach my $key (keys %{ $strings }) {
                    my $val = $strings->{$key};
                    if ($val =~ /$detail/) {
                        print $indent .  '  id  ' . "\t: " . $key . ' => ' . $val . "\n";
                    }
                }
            }
        }
    }

    $level++;
    my @children = @{ $element->{children} };
    foreach (@children) {
        $self->_get_page($_, $level);
    }
}

sub _source_window_with_children {
    my ($self, $index) = @_;
    $index //= 0;

    my $window = $self->execute_script('UIATarget.localTarget().frontMostApp().windows()[' . $index . '].getTree()');
    if (scalar @{ $window->{children} }) {
        return $window;
    }
    else {
        return $self->_source_window_with_children(++$index);
    }
}

1;
