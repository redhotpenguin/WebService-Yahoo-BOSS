package WebService::Yahoo::BOSS;

=head1 NAME

WebService::Yahoo::BOSS - Interface to the Yahoo BOSS API

=cut

use Moo;

use Any::URI::Escape;
use LWP::UserAgent;
use URI;
use Net::OAuth;
use Data::Dumper;
use Data::UUID;
use Carp qw(croak);

use WebService::Yahoo::BOSS::Response;
use WebService::Yahoo::BOSS::Response::Web;

our $VERSION = '0.08';

my $Ug = Data::UUID->new;

$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

has 'ckey'    => ( is => 'ro', required => 1 );
has 'csecret' => ( is => 'ro', required => 1 );

has 'url'     => (
    is       => 'ro',
    default  => "http://yboss.yahooapis.com",
);

has 'ua' => (
    is => 'ro',
    default => sub {
        LWP::UserAgent->new(
            agent => __PACKAGE__ . '_' . $VERSION,
            keep_alive => 1, # cache connection
        );
    }
);


sub _create_boss_request {
    my ($self, $api_path, $args) = @_;

    # Create request
    my $request = Net::OAuth->request("request token")->new(
        consumer_key     => $self->ckey,
        consumer_secret  => $self->csecret,
        request_url      => $self->url . $api_path,
        request_method   => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => $Ug->to_string( $Ug->create ),
        extra_params     => $args,
        callback         => '',
    );

    $request->sign;

    return $request;
}


sub _perform_boss_request {
    my ($self, $request) = @_;

    my $res = $self->ua->get( $request->to_url );
    unless ( $res->is_success ) {
        my $url = $request->to_url;
        die "bad response from $url: " . Dumper($res);
    }
    return $res->decoded_content;
}


sub _parse_boss_response {
    my ($self, $response_content, $result_class) = @_;
    return WebService::Yahoo::BOSS::Response->parse( $response_content, 'WebService::Yahoo::BOSS::Response::Web' );
}


sub ask_boss {
    my ($self, $api_path, $args, $result_class) = @_;

    my $request = $self->_create_boss_request($api_path, $args);
    my $response_content = $self->_perform_boss_request($request);
    my $response = $self->_parse_boss_response($response_content, $result_class);

    return $response;
}


sub Web {
    my ( $self, %args ) = @_;

    croak "q parameter not defined"
        unless defined $args{q};

    $args{count} ||= 10;
    $args{filter} ||= '-porn';
    $args{format} ||= 'json';
    croak 'only json format supported'
        unless $args{format} eq 'json';

    return $self->ask_boss('/ysearch/web', \%args, 'WebService::Yahoo::BOSS::Response::Web');
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
