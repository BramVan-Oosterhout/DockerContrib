package Foswiki::Contrib::DockerContrib::Dieken;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/Dieken/foswiki-docker',
			owner => 'dieken',
			dockerfile => 'Dockerfile',
			path => '../lib/Docker/dieken',
			image => 'foswiki'
			};
	bless $self, $class;
	return $self;

}



1;