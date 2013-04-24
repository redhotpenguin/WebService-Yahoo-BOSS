#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my $boss = require 't/prologue.pl';

my $search = $boss->Web( q => 'sushi' );
isa_ok( $search, 'WebService::Yahoo::BOSS::Response' );
isa_ok( $search->results->[0], 'WebService::Yahoo::BOSS::Response::Web');

done_testing();
