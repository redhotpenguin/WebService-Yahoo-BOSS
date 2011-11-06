package WebService::Yahoo::BOSS::Response::Web;

=head1 NAME

WebService::Yahoo::BOSS::Response::Web

=cut

use strict;
use warnings;

use Any::Moose;

has 'abstract' => ( is => 'rw', isa => 'Str', required => 1 );
has 'date'     => ( is => 'ro', isa => 'Str', required => 1 );
has 'dispurl'  => ( is => 'ro', isa => 'Str', required => 1 );
has 'title'    => ( is => 'rw', isa => 'Str', required => 1 );
has 'url'      => ( is => 'ro', isa => 'Str', required => 1 );
has 'clickurl' => ( is => 'ro', isa => 'Str', required => 1 );


1;
