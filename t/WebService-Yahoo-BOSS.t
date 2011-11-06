#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;
BEGIN { use_ok('WebService::Yahoo::BOSS') }
BEGIN { use_ok('WebService::Yahoo::BOSS::Response') }
BEGIN { use_ok('WebService::Yahoo::BOSS::Response::Web') }

can_ok( 'WebService::Yahoo::BOSS', qw( Web ) );

SKIP: {
    skip "env YBOSS_CKEY YBOSS_CSECRET undefined", 3,
      unless ( $ENV{YBOSS_CKEY} && $ENV{YBOSS_CSECRET} );

    my $boss = WebService::Yahoo::BOSS->new(
        ckey    => $ENV{YBOSS_CKEY},
        csecret => $ENV{YBOSS_CSECRET}
    );
    isa_ok( $boss, 'WebService::Yahoo::BOSS' );
    my $search = $boss->Web( q => 'sushi' );
    isa_ok( $search, 'WebService::Yahoo::BOSS::Response' );
    isa_ok( $search->results->[0], 'WebService::Yahoo::BOSS::Response::Web');
}


