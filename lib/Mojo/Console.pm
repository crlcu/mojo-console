package Mojo::Console;
use Mojo::Base 'Mojolicious::Command';

use List::Util qw(any none);

use Mojo::Console::Input;
use Mojo::Console::Output;

our $VERSION = '0.0.1';

has 'input' => sub { Mojo::Console::Input->new };
has 'max_attempts' => 10;
has 'output' => sub { Mojo::Console::Output->new };

sub ask {
    my ($self, $message, $required) = @_;

    my $attempts = $self->max_attempts;
    my $answer = '';

    while ((($required || $attempts == 10) && !$answer) && $attempts--) {
        $self->line($message . ' ');
        $answer = $self->input->ask;
    }

    if ($attempts < 0) {
        $self->error("Please answer the question.\n");
    }

    return $answer;
}

sub confirm {
    my ($self, $message, $default) = @_;

    my $default_yes = (any { lc($default || '') eq $_ } qw/y yes/);
    my $default_no = (any { lc($default || '') eq $_ } qw/n no/);

    my $attempts = $self->max_attempts;
    my $answer = '';

    while ((none { lc($answer) eq $_ } qw/y yes n no/) && $attempts--) {
        $self->line($message);

        $self->success(' [yes/no] ');

        if ($default) {
            $self->warn(sprintf('[default=%s] ', $default));
        }

        $answer = $self->input->ask || $default;
    }

    if ($attempts < 0) {
        $self->error("Please answer with [yes/no]\n");
    }

    return (any { lc($answer) eq $_ } qw/y yes/) ? 1 : 0;
}

sub choice {
    my ($self, $message, $choices, $default) = @_;

    my $attempts = $self->max_attempts;
    my $answer = '';

    while ((none { $answer eq $_ } @$choices) && $attempts--) {
        $self->line($message);
        $self->success(sprintf(' [%s] ', join(', ', @$choices)));

        if ($default) {
            $self->warn(sprintf('[default=%s] ', $default));
        }

        $answer = $self->input->ask || $default;
    }

    if ($attempts < 0) {
        $self->error(sprintf("Please chose one of the following options: [%s] \n", join(', ', @$choices)));
    }

    return $answer;
}

sub error {
    return shift->output->error(@_);
}

sub info {
    return shift->output->info(@_);
}

sub line {
    return shift->output->line(@_);
}

sub newline {
    return shift->output->newline(@_);
}

sub success {
    return shift->output->success(@_);
}

sub warn {
    return shift->output->warn(@_);
}

1;
