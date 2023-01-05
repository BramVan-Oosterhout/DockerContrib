package Foswiki::Contrib::DockerContrib::TimLegge;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/timlegge/docker-foswiki',
			owner => 'timlegge',
			dockerfile => 'Dockerfile',
			path => '../lib/Docker/timlegge',
			image => 'timlegge/dockerfoswiki',
			type => { simple => '../lib/Docker/timlegge/docker-compose.1-simple.yml',
					  'simple-https' => '../lib/Docker/timlegge/docker-compose.2-simple-https.yml',
					  },
			};
	bless $self, $class;
	return $self;

}

1;