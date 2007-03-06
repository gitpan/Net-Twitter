use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Net::Twitter',
    license             => 'perl',
    dist_author         => 'Chris Thompson <cpan@cthompson.com>',
    dist_version_from   => 'lib/Net/Twitter.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Net-Twitter-*' ],
);

$builder->create_build_script();
