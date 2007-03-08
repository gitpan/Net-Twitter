use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::Twitter',
    AUTHOR              => 'Chris Thompson <cpan@cthompson.com>',
    VERSION_FROM        => 'lib/Net/Twitter.pm',
    ABSTRACT_FROM       => 'lib/Net/Twitter.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'JSON'	     => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-Twitter-*' },
);
