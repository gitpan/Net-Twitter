##############################################################################
# Net::Twitter - Perl OO interface to www.twitter.com
# v1.02
# Copyright (c) 2007 Chris Thompson
##############################################################################

package Net::Twitter;
$VERSION ="1.02";
use warnings;
use strict;

use LWP::UserAgent;

BEGIN { 
	require constant;
	eval { 
		require JSON::Syck;
		JSON::Syck->import();
	};
	
	unless($@) {
		constant->import(JSON_SYCK => 1);
	}
	else {
		eval { require JSON; JSON->import() };
		die "Couldn't find a JSON Package, install JSON::Syck or JSON" if $@;
		constant->import(JSON_SYCK => 0);
	}
}

sub new {
    my $class = shift;
    my %conf = @_;
    
    $conf{apiurl} = 'http://twitter.com/statuses' unless defined $conf{apiurl};
    $conf{apihost} = 'twitter.com:80' unless defined $conf{apihost};
    $conf{apirealm} = 'Twitter API' unless defined $conf{apirealm};
    
    $conf{ua} = LWP::UserAgent->new();
    $conf{ua}->credentials($conf{apihost},
    			$conf{apirealm},
			$conf{username},
			$conf{password}
			);

    $conf{ua}->env_proxy();

    return bless {%conf}, $class;
}

sub _parse_json {
    my ( $self, $json ) = @_;	
    
    if (JSON_SYCK) {
       return JSON::Syck::Load($json);
    } else {
       return JSON::jsonToObj($json);
    }
    
}

sub update {
    my ( $self, $status ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/update.json", [ status => $status ]);
    return ($req->is_success) ?  $self->_parse_json($req->content) : undef;
}

sub followers {
    my ( $self ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/followers.json");
    return ($req->is_success) ?  $self->_parse_json($req->content) : undef;

}

sub friends {
    my ( $self ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/friends.json");
    return ($req->is_success) ?  $self->_parse_json($req->content) : undef;

}

sub friends_timeline {
    my ( $self ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/friends_timeline.json");
    return ($req->is_success) ?  $self->_parse_json($req->content) : undef;

}

sub public_timeline {
    my ( $self ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/public_timeline.json");
    return ($req->is_success) ?  $self->_parse_json($req->content) : undef;

}



1;
__END__

=head1 NAME

Net::Twitter - Perl interface to twitter.com

=head1 VERSION

This document describes Net::Twitter version 1.0.1

=head1 SYNOPSIS

#!/usr/bin/perl

use Net::Twitter;

my $bot = Net::Twitter->new(username=>"myuser", password=>"mypass" );

$bot->update("My current Status");

=head1 DESCRIPTION

http://www.twitter.com provides a web 2.0 type of ubiquitous presence.
This module allows you to set your status, as well as the statuses of
your friends.


=head1 INTERFACE

Net::Twitter exports the following methods.

=over

=item C< new >

You must supply a hash containing the configuration for the connection.

Valid configuration items are:

=over

=item C< username >

Username of your account at twitter.com. This is usually your email address. 
REQUIRED.

=item C< password >

Password of your account at twitter.com. REQUIRED.

=item C< apiurl >

OPTIONAL. The URL of the API for twitter.com. This defaults to 
C< http://twitter.com/statuses > if not set.

=item C< apihost >

=item C< apirealm >

OPTIONAL: If you do point to a different URL, you will also need to set C< apihost > and
C< apirealm > so that the internal LWP can authenticate. 

C< apihost > defaults to C< www.twitter.com:80 >.

C< apirealm > defaults to C< Twitter API >.

=back

=item C< update >

Set your current status. This returns a hashref containing your most
recent status. Returns undef if an error occurs.
	
=item C< friends >

This returns a hashref containing the most recent status of those you
have marked as friends in twitter. Returns undef if an error occurs.

=item C< friends_timeline >

This returns a hashref containing the timeline of those you
have marked as friends in twitter. Returns undef if an error occurs.

=item C< public_timeline >

This returns a hashref containing the public timeline of all twitter
users. Returns undef if an error occurs.
	
=item C< followers >

This returns a hashref containing the timeline of those who follow your
status in twitter.. Returns undef if an error occurs.

=back

=head1 CONFIGURATION AND ENVIRONMENT
  
Net::Twitter uses LWP internally. Any environment variables that LWP
supports should be supported by Net::Twitter. I hope.

=head1 DEPENDENCIES

=over

=item L<LWP::UserAgent>

=item L<JSON::Syck> (preferred) or L<JSON>

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-net-twitter@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Chris Thompson <cpan@cthompson.com>

The framework of this module is shamelessly stolen from L<Net::AIML>. Big
ups to Chris "perigrin" Prather for that.
    
The fallback code to load JSON or JSON::Syck is also from Chris Prather.
    
=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Chris Thompson <cpan@cthompson.com>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
