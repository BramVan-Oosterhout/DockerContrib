package Foswiki::Contrib::DockerContrib::Dieken;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/Dieken/foswiki-docker',
			branch => 'main',
			containerName => 'dieken',
			dockerfile => 'Dockerfile',
			image => 'foswiki',
			@_
			};
	bless $self, $class;
	return $self;

}

sub postInstall{
	# No post install
}



1;