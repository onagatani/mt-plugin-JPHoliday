package JPHoliday::UA;
use strict;
use warnings;
use utf8;
use Carp 'croak';
use Sub::Retry;
use LWP::UserAgent;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/timeout try delay/],
);

sub new {
    my $class = shift;
    my $self = bless {
        timeout => '5',
        try     => '3',
        delay   => '1',
        @_
    }, ref $class || $class;
    return $self;
}

sub get {
    my ($self, $url) = @_;

    my $res = retry $self->try, $self->delay, sub {
        $self->_ua->get($url);
    }, sub { 
        my $res = shift;
        return $res->is_success ? 0 : 1;
    };

    croak($url) unless $res;
    return $res->content;
}

sub _ua {
    my $self = shift;

    my $ua = LWP::UserAgent->new(ssl_opts => +{
        verify_hostname => 0,
    });

    $ua->timeout($self->timeout);
    $ua->agent('MT-Plugin-JPHoliday/0.1');
    return $ua;
}

1;
__END__


