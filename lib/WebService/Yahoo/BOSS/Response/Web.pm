package WebService::Yahoo::BOSS::Response::Web;

=head1 NAME

WebService::Yahoo::BOSS::Response::Web

=cut

use Moo;

has 'abstract' => ( is => 'rw', required => 1 );
has 'date'     => ( is => 'ro', required => 1 );
has 'dispurl'  => ( is => 'ro', required => 1 );
has 'title'    => ( is => 'rw', required => 1 );
has 'url'      => ( is => 'ro', required => 1 );
has 'clickurl' => ( is => 'ro', required => 1 );


1;
