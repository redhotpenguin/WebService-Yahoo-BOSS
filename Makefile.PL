#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'WebService::Yahoo::BOSS',
    VERSION_FROM => 'lib/WebService/Yahoo/BOSS.pm',
    PREREQ_PM    => {
        'Any::Moose'       => 0,
        'Any::URI::Escape' => 0,
        'LWP::UserAgent'   => 0,
        'Net::OAuth'       => 0.27,
        'Data::UUID'       => 1.217,
        'JSON::XS'         => 2.32,
    },
    ABSTRACT_FROM => 'lib/WebService/Yahoo/BOSS.pm',
    AUTHOR        => 'Fred Moyer <fred@slwifi.com>'
);
