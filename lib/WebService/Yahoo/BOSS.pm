package WebService::Yahoo::BOSS;

=head1 NAME

WebService::Yahoo::BOSS - Interface to the Yahoo BOSS API

=cut

use strict;
use warnings;

use Any::Moose;
use Any::URI::Escape;
use LWP::UserAgent;
use URI;
use Net::OAuth;
use Data::Dumper;
use Data::UUID;
use WebService::Yahoo::BOSS::Response;

our $VERSION = '0.08';

our $Ua = LWP::UserAgent->new( agent => __PACKAGE__ . '_' . $VERSION );

our $Api_host = 'yboss.yahooapis.com';
our $Api_base = "http://$Api_host";

my $Ug = Data::UUID->new;

$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

has 'ckey'    => ( is => 'ro', isa => 'Str', required => 1 );
has 'csecret' => ( is => 'ro', isa => 'Str', required => 1 );
has 'url'     => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => $Api_base,
);

sub Web {
    my ( $self, %args ) = @_;

    unless ( $args{q} && ( $args{q} ne '' ) ) {
        die "query param needed to search";
    }

    $args{format} ||= 'json';
    $args{count} || = 10;
    die 'only json format supported, xml patches welcome'
      unless $args{format} eq 'json';

    $args{filter} = '-porn';

    # build the endpoint
    my $url  = $self->url . '/ysearch/web';
    my $uuid = $Ug->to_string( $Ug->create() );

    # Create request
    my $request = Net::OAuth->request("request token")->new(
        consumer_key     => $self->ckey,
        consumer_secret  => $self->csecret,
        request_url      => $url,
        request_method   => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => $uuid,
        extra_params     => \%args,
        callback         => 'http://printer.example.com/request_token_ready',
    );

    # Sign request
    $request->sign;

    # Get message to the Service Provider
    my $res = $Ua->get( $request->to_url );

    unless ( $res->is_success ) {

        die "bad response: " . Dumper($res);
    }

    my $response =
      WebService::Yahoo::BOSS::Response->parse( $res->decoded_content );

    return $response;
}

1;

=head1 SYNOPSIS

 use WebService::Yahoo::BOSS;

 $Boss = WebService::Yahoo::BOSS->new( ckey => $ckey, csecret => $csecret );

 $res = $Boss->Web( q       => 'microbrew award winner 2010',
                    start   => 0,
                    exclude => 'pilsner', );

 # see source for result attributes

=head1 DESCRIPTION

This API wraps the Yahoo BOSS (Build Your Own Search) web service API.

Mad props to Yahoo for putting out a premium search api which encourages
innovative use.

For more information check out the following links.  This is a work in
progress, so patches welcome!

=head1 SEE ALSO

 http://developer.yahoo.com/search/boss/boss_api_guide

 L<Google::Search>

=head1 AUTHOR

"Fred Moyer", E<lt>fred@slwifi.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Silver Lining Networks

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
