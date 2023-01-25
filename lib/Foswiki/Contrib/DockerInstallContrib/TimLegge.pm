package Foswiki::Contrib::DockerContrib::TimLegge;
use parent Foswiki::Contrib::DockerContrib;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
			source => 'https://github.com/BramVan-Oosterhout/docker-foswiki',
			branch => 'master',
			containerName => 'timlegge',
			dockerfile => 'Dockerfile',
			image => 'timlegge/dockerfoswiki',
			type => { simple => 'docker-compose.1-simple.yml',
					  'simple-https' => 'docker-compose.2-simple-https.yml',
					  },
			@_
			};
	bless $self, $class;
	return $self;

}

sub postInstall{
	
	my $this = shift;
	
	$this->SUPER::postInstall();
	
	print STDOUT "Provide password for Foswiki user 'admin': ";
	my $passwd = <STDIN>;
	chomp $passwd;
	
	my $shParam = join( " ", '-c "cd /var/www/foswiki;',
						  'tools/configure -save',
						  "-set {Password}=\'$passwd\'",
						  '"'
                  );
	my @cmd = qq( docker exec -it $this->{containerName} sh $shParam );	
	$this->do_command( @cmd );
} 

1;