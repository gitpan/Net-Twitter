##############################################################################
# Net::Twitter - Perl OO interface to www.twitter.com
# v1.05
# Copyright (c) 2007 Chris Thompson
##############################################################################

package Net::Twitter;
$VERSION ="1.05";
use warnings;
use strict;

use LWP::UserAgent;
use JSON::Any;

sub new {
    my $class = shift;
    my %conf = @_;
    
    $conf{apiurl} = 'http://twitter.com' unless defined $conf{apiurl};
    $conf{apihost} = 'twitter.com:80' unless defined $conf{apihost};
    $conf{apirealm} = 'Twitter API' unless defined $conf{apirealm};
    $conf{useragent} = "Net::Twitter/$Net::Twitter::VERSION (PERL)" unless defined $conf{useragent};
    $conf{clientname} = 'Perl Net::Twitter' unless defined $conf{clientname};
    $conf{clientver} = $Net::Twitter::VERSION unless defined $conf{clientver};
    $conf{clienturl} = "http://x4.net/twitter/meta.xml" unless defined $conf{clienturl};


    $conf{ua} = LWP::UserAgent->new();
    $conf{ua}->credentials($conf{apihost},
    			$conf{apirealm},
				$conf{username},
				$conf{password}
			);
    $conf{ua}->agent("Net::Twitter/$Net::Twitter::VERSION");
    $conf{ua}->default_header( "X-Twitter-Client:" => $conf{clientname} );
    $conf{ua}->default_header( "X-Twitter-Client-Version:" => $conf{clientver} );
    $conf{ua}->default_header( "X-Twitter-Client-URL:" => $conf{clienturl} );

    $conf{ua}->env_proxy();

    return bless {%conf}, $class;
}

sub credentials {
my ($self, $username, $password, $apihost, $apirealm) = @_;

$apirealm ||= 'Twitter API';
$apihost ||= 'twitter.com:80';

    $self->{ua}->credentials($apihost,
    			$apirealm,
			$username,
			$password
			);
}


########################################################################
#### STATUS METHODS
########################################################################

sub public_timeline {
    my ( $self, $since_id ) = @_;

    my $url = $self->{apiurl} . "/statuses/public_timeline.json";
    $url .= ($since_id) ? '?since_id=' . $since_id : "";

    my $req=$self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub friends_timeline {
    my ( $self, $args ) = @_;

    my $url = $self->{apiurl} . "/statuses/friends_timeline";
    $url .= (defined $args->{id}) ? "/" . $args->{id} . ".json" : ".json";
    if ((defined $args->{since}) or (defined $args->{page})) {
    $url .= "?";
    $url .= (defined $args->{since}) ? "since=" . $args->{since} . "&" : "";
    $url .= (defined $args->{page}) ? "page=" . $args->{page} : "";
    }
    my $req = $self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub user_timeline {
    my ( $self, $args ) = @_;

    my $url = $self->{apiurl} . "/statuses/user_timeline";
    $url .= (defined $args->{id}) ? "/" . $args->{id} . ".json" : ".json";

    if ((defined $args->{since}) || (defined $args->{count})) {
 	$url .= "?";
	$url .=	(defined $args->{since}) ? 'since=' . $args->{since} . "&" : "";
	$url .= (defined $args->{count}) ? 'count=' . $args->{count} : "";
    }
    my $req = $self->{ua}->get($url);
		
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub show_status {
    my ( $self, $id ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/statuses/show/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub update {
    my ( $self, $status ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/statuses/update.json", [ status => $status ]);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub replies {
    my ( $self, $page) = @_;

    my $url = $self->{apiurl} . "/statuses/replies.json";
    $url .=   ($page) ? '?page=' . $page : "";

    my $req = $self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub destroy_status {
    my ( $self, $id ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/statuses/destroy/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

########################################################################
#### USER METHODS
########################################################################

sub friends {
    my ( $self, $id ) = @_;
    my $url = $self->{apiurl} . "/statuses/friends" ;
       $url .= (defined $id) ? "/$id.json" : ".json";
    my $req = $self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub followers {
    my ( $self ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/statuses/followers.json"); 
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub featured {
    my ( $self ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/statuses/featured.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub show_user {
    my ( $self, $id ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/users/show/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

########################################################################
#### DIRECT MESSAGE METHODS
########################################################################

sub direct_messages {
    my ( $self, $args ) = @_;

    my $url = $self->{apiurl} . "/direct_messages.json";
      if (defined $args) {
       $url .= "?";
       $url .= (defined $args->{since}) ? 'since=' . $args->{since} . "&" : "";
       $url .= (defined $args->{since_id}) ? 'since_id=' . $args->{since_id} . "&" : "";
       $url .= (defined $args->{page}) ? 'page=' . $args->{page} : "";
      }

    my $req = $self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub sent_direct_messages {
    my ( $self, $args ) = @_;

    my $url = $self->{apiurl} . "/direct_messages/sent.json";
      if (defined $args) {
       $url .= "?";
       $url .= (defined $args->{since}) ? 'since=' . $args->{since} . "&" : "";
       $url .= (defined $args->{since_id}) ? 'since_id=' . $args->{since_id} . "&" : "";
       $url .= (defined $args->{page}) ? 'page=' . $args->{page} : "";
      }

    my $req = $self->{ua}->get($url);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub new_direct_message {
    my ( $self, $args ) = @_;

    my $req = $self->{ua}->post($self->{apiurl} . "/direct_messages/new.json", $args);
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;

}

sub destroy_direct_message {
    my ( $self, $id ) = @_;

    my $req = $self->{ua}->get($self->{apiurl} . "/direct_messages/destroy/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

########################################################################
#### FRIENDSHIP METHODS
########################################################################

sub create_friend {
    my ( $self, $id ) = @_;

    my $req=$self->{ua}->get($self->{apiurl}."/friendships/create/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub destroy_friend {
    my ( $self, $id ) = @_;

    my $req=$self->{ua}->get($self->{apiurl}."/friendships/destroy/$id.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

########################################################################
#### ACCOUNT METHODS
########################################################################

sub verify_credentials {
    my ( $self ) = @_;

    my $req=$self->{ua}->get($self->{apiurl}."/account/verify_credentials.json");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

sub end_session {
    my ( $self ) = @_;

    my $req=$self->{ua}->get($self->{apiurl}."/account/end_session");
    return ($req->is_success) ?  JSON::Any->jsonToObj($req->content) : undef;
}

1;
__END__

=head1 NAME

Net::Twitter - Perl interface to twitter.com

=head1 VERSION

This document describes Net::Twitter version 1.05

=head1 SYNOPSIS

   #!/usr/bin/perl

   use Net::Twitter;

   my $twit = Net::Twitter->new(username=>"myuser", password=>"mypass" );

   $result = $twit->update("My current Status");

   $twit->credentials("otheruser", "otherpass");

   $result = $twit->update("Status for otheruser");

=head1 DESCRIPTION

http://www.twitter.com provides a web 2.0 type of ubiquitous presence.
This module allows you to set your status, as well as the statuses of
your friends.

You can view the latest status of Net::Twitter on it's own twitter timeline
at http://twitter.com/net_twitter


=head1 INTERFACE

Net::Twitter exports the following methods.

=cut

=item C<new(...)>

You must supply a hash containing the configuration for the connection.

Valid configuration items are:

=over

=item C<username>

Username of your account at twitter.com. This is usually your email address. 
REQUIRED.

=item C<password>

Password of your account at twitter.com. REQUIRED.

=item C<useragent>

OPTIONAL: Sets the User Agent header in the HTTP request. If omitted, this will default to
"Net::Twitter/$Net::Twitter::Version (Perl)"

=item C<clientname>

OPTIONAL: Sets the X-Twitter-Client-Name: HTTP Header. If omitted, this defaults to
"Perl Net::Twitter"

=item C<clientver>

OPTIONAL: Sets the X-Twitter-Client-Version: HTTP Header. If omitted, this defaults to
the current Net::Twitter version, $Net::Twitter::VERSION.

=item C<clienturl>

OPTIONAL: Sets the X-Twitter-Client-URL: HTTP Header. If omitted, this defaults to
C<http://x4.net/Net-Twitter/meta.xml>. By standard, this file should be in XML format, as at the
default location.

=item C<apiurl>

OPTIONAL. The URL of the API for twitter.com. This defaults to 
C<http://twitter.com/> if not set.

B<NOTICE: As of Net::Twitter 1.05 the default URL has changed from C<http://twitter.com/statuses> to
C<http://twitter.com/> to reflect the expansion of the API outside the C</statuses> area. If your
code was written to Net::Twitter 1.04 or earlier, and you set apiurl, including /statuses in the URL, 
you will have to remove it. the top level "directory" for the API is now added individually in each
method.>

=item C<apihost>

=item C<apirealm>

OPTIONAL: If you do point to a different URL, you will also need to set C<apihost> and
C<apirealm> so that the internal LWP can authenticate. 

C<apihost> defaults to C<www.twitter.com:80>.

C<apirealm> defaults to C<Twitter API>.

=back

=item C<credentials($username, $password, $apihost, $apiurl)>

Change the credentials for logging into twitter. This is helpful when managing
multiple accounts.

C<apirealm> and C<apihost> are optional and will default to the standard
twitter versions if omitted.

=item C<update($status)>

Set your current status. This returns a hashref containing your most
recent status. Returns undef if an error occurs.

=item C<replies([$page])>

Returns the 20 most recent replies (status updates prefixed with @username 
posted by users who are friends with the user being replied to) to the 
authenticating user.

Accepts an optional argument for page to retrieve, which will the 20 next 
most recent statuses from the authenticating user and that user's friends, 
eg "page=3"

=item C<featured()>

This returns a hashref containing a list of the users currently 
featured on the site with their current statuses inline. Returns undef if an error occurs.

	
=item C<friends()>

This returns a hashref containing the most recent status of those you
have marked as friends in twitter. Returns undef if an error occurs.

=item C<friends_timeline(...)>

This returns a hashref containing the timeline of those you
have marked as friends in twitter. Returns undef if an error occurs.

Accepts an optional argument hashref:

=over
=item C<id>

User id or email address of a user other than the authenticated user,
in order to retrieve that user's friends_timeline.

=item C<since>

Narrows the returned results to just those statuses created after the
specified HTTP-formatted date.

=item C<page>

Gets the 20 next most recent statuses from the authenticating user and that user's friends, eg "page=3"

=back

=item C<user_timeline(...)>

This returns a hashref containing the timeline of the authenticating user. Returns undef if an error occurs.

Accepts an optional argument of a hashref:

=over

=item C<id>

ID or email address of a user other than the authenticated user, in order to retrieve that user's friends_timeline.

=item C<count>

Narrows the returned results to a certain number of statuses. This is limited to 20.

=item C<since>
Narrows the returned results to just those statuses created after the 
specified HTTP-formatted date.

=back

=item C<destroy_status($id)>

Destroys the status specified by the required ID parameter.  The 
authenticating user must be the author of the specified status.

=item C<destroy_friend($id)>

Discontinues friendship with the user specified in the ID parameter as the 
authenticating user.  Returns the un-friended user in the requested format 
when successful.

=item C<show_status($id)>

Returns status of a single tweet.  The status' author will be returned inline.

The argument is the ID or email address of the twitter user to pull, and is REQUIRED.

=item C<show_user($id)>

Returns extended information of a single user.

The argument is the ID or email address of the twitter user to pull, and is REQUIRED.

=item C<public_timeline([12345])>

This returns a hashref containing the public timeline of all twitter
users. Returns undef if an error occurs.

Accepts an optional argument containing a status ID, and limits
responses to only statuses greater than this ID
	
=item C<followers()>

This returns a hashref containing the timeline of those who follow your
status in twitter. Returns undef if an error occurs.

=item C<direct_messages()>

Returns a list of the direct messages sent to the authenticating user.

Accepts an optional hashref for arguments:

=over

=item C<page>

Retrieves the 20 next most recent direct messages.

=item C<since>

Narrows the returned results to just those statuses created after the
specified HTTP-formatted date.

=item C<since_id>

Narrows the returned results to just those statuses created after the
specified ID.

=back

=item C<sent_direct_messages()>

Returns a list of the direct messages sent by the authenticating user.

Accepts an optional hashref for arguments:

=over

=item C<page>

Retrieves the 20 next most recent direct messages.

=item C<since>

Narrows the returned results to just those statuses created after the
specified HTTP-formatted date.

=item C<since_id>

Narrows the returned results to just those statuses created after the
specified ID.

=back

=item C<new_direct_message($args)>

Sends a new direct message to the specified user from the authenticating user. 

REQUIRES an argument of a hashref:

=over

=item C<user>

ID or email address of user to send direct message to.

=item C<text>

Text of direct message.

=back

=item C<destroy_direct_message($id)>

Destroys the direct message specified in the required ID parameter.  The 
authenticating user must be the recipient of the specified direct message.

=head1 CONFIGURATION AND ENVIRONMENT
  
Net::Twitter uses LWP internally. Any environment variables that LWP
supports should be supported by Net::Twitter. I hope.

=head1 DEPENDENCIES

=over

=item L<LWP::UserAgent>

=item L<JSON::Any>

Starting with version 1.04, Net::Twitter requires JSON::Any instead of a specific
JSON handler module. Net::Twitter currently accepts JSON::Any's default order
for loading handlers.

=back

=head1 INCOMPATIBILITIES

The X-Twitter-Client-Name, X-Twitter-Client-Version, and X-Twitter-Client-URL, headers (See: C<new>)
are currently a de facto standard that have not been fully codified and accepted by Twitter.

Though they are expected to be accepted as valid (And optional), they could possibly 
change in the future.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-net-twitter@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Chris Thompson <cpan@cthompson.com>

The framework of this module is shamelessly stolen from L<Net::AIML>. Big
ups to Chris "perigrin" Prather for that.
       
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
