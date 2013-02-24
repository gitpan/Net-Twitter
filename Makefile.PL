
use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Net::Twitter implementation",
  "AUTHOR" => "Marc Mims <mmims\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Carp" => 0,
    "File::Find" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "HTTP::Response" => 0,
    "LWP::UserAgent" => "5.819",
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "Test::Simple" => "0.98",
    "Test::Warn" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Net-Twitter",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Net::Twitter",
  "PREREQ_PM" => {
    "Carp::Clan" => 0,
    "Data::Visitor::Callback" => 0,
    "DateTime" => 0,
    "DateTime::Format::Strptime" => 0,
    "Devel::StackTrace" => 0,
    "Digest::SHA" => 0,
    "Encode" => 0,
    "HTML::Entities" => 0,
    "HTTP::Request::Common" => 0,
    "JSON" => 0,
    "List::Util" => 0,
    "Moose" => 0,
    "Moose::Exporter" => 0,
    "Moose::Meta::Method" => 0,
    "Moose::Role" => 0,
    "MooseX::Aliases" => 0,
    "MooseX::Role::Parameterized" => 0,
    "Net::Netrc" => 0,
    "Net::OAuth" => 0,
    "Scalar::Util" => 0,
    "Time::HiRes" => 0,
    "Try::Tiny" => 0,
    "URI" => 0,
    "URI::Escape" => 0,
    "namespace::autoclean" => 0,
    "overload" => 0
  },
  "VERSION" => "4.00002",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



