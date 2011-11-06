package WebService::Yahoo::BOSS::Response;

=head1 NAME

WebService::Yahoo::BOSS::Response - Response class for Yahoo BOSS searches

=cut

use strict;
use warnings;

use Any::Moose;
use JSON::XS ();
use Data::Dumper;

use WebService::Yahoo::BOSS::Response::Web;

has 'count'        => ( is => 'ro', isa => 'Int',              required => 1 );
has 'totalresults' => ( is => 'ro', isa => 'Int',              required => 1 );
has 'start'        => ( is => 'ro', isa => 'Int',              required => 1 );
has 'results'      => ( is => 'ro', isa => 'ArrayRef[Object]', required => 1 );

sub parse {
    my ( $class, $content ) = @_;

    my $response = JSON::XS::decode_json($content);

    my $rc = $response->{bossresponse}->{responsecode};

    die "Boss response contains error: " . Dumper($response) unless $rc == 200;

    my $web = $response->{bossresponse}->{web};

    my @webresults;
    foreach my $result ( @{ $web->{results} } ) {

        my $webresult = WebService::Yahoo::BOSS::Response::Web->new($result);
        push @webresults, $webresult;
    }

    my $self = $class->new(
        count        => $web->{count},
        totalresults => $web->{totalresults},
        results      => \@webresults,
        start        => $web->{start}
    );

    return $self;
}

1;
