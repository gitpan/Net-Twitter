#!perl
use warnings;
use strict;
use Test::More tests => 4;
use Test::Exception;
use lib qw(t/lib);
use Mock::LWP::UserAgent;
use Net::Twitter;

my $nt = Net::Twitter->new(
    traits   => [qw/API::REST/],
    username => 'just_me',
    password => 'secret',
);

my $ua = $nt->ua;

# things that should fail
throws_ok { $nt->relationship_exists(qw/one two three/) } qr/expected 2 args/, 'too many args';
throws_ok {
    Net::Twitter->new(useragent_class => 'NoSuchModule::Test7701')
} qr/Can't locate NoSuchModule/, 'bad useragent_class';
throws_ok { $nt->show_status([ 123 ]) } qr/must not be a reference/, 'wrong type';
throws_ok { $nt->friends({ count => 30, page => 4 }, 'extra') }
        qr/must not be a reference/, 'extra args';

exit 0;
