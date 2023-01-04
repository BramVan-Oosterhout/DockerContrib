package Foswiki::Contrib::DockerContrib::TimLegge;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/timlegge/docker-foswiki',
			dockerfile => 'Dockerfile',
			path => '../lib/Docker/timlegge',
			image => 'timlegge/dockerfoswiki',
			type => { simple => 'docker-compose.1-simple.yml',
					  'simple-https' => 'docker-compose.2-simple-https.yml',
					  },
			};
	bless $self, $class;
	return $self;

}

1;