package Mojo::Console::Input;
use Mojo::Base -base;

sub ask {
    my $self = shift;

    my $answer = <STDIN>;
    chomp $answer;

    return $answer;
}

1;
