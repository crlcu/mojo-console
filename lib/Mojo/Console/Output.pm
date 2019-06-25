package Mojo::Console::Output;
use Mojo::Base -base;

use Term::ANSIColor;

has 'sameline' => 1;

sub error {
    shift->wrap(@_, 'bright_red', 1);
}

sub info {
    shift->wrap(@_, 'bright_cyan');
}

sub line {
    shift->wrap(@_);
}

sub newline {
    my $self = shift;

    my $sameline = $self->sameline;
    $self->sameline(0);

    $self->wrap(@_);

    $self->sameline($sameline);
}

sub success {
    shift->wrap(@_, 'bright_green');
}

sub warn {
    shift->wrap(@_, 'bright_yellow');
}

sub wrap {
    my ($self, $message, $color, $error) = @_;

    $error ||= 0;

    if ($error) {
        print STDERR color($color) if ($color);
        print STDERR $message;
        print STDERR color('reset') if ($color);

        exit;
    } else {
        print STDOUT color($color) if ($color);
        print STDOUT sprintf("%s%s", $message, ($self->sameline ? '' : "\n"));
        print STDOUT color('reset') if ($color);
    }
}

1;
