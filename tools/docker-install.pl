use strict;
use warnings;
use Getopt::Long; 

BEGIN {
	unshift @INC, '../lib';
}

use Foswiki::Contrib::DockerContrib::Dieken;
use Foswiki::Contrib::DockerContrib::TimLegge;
use Foswiki::Contrib::DockerContrib::Bram;

use Net::EmptyPort;

my $source = { dieken => 'Dieken',
			   timlegge => 'TimLegge',
			   bram => 'Bram',
			   };
my $request = shift @ARGV;
my $type = 'docker';	#default docker runls tools

my $build = 0; 			# default: no build
my $verbose = 0;        # default: no chatter

exit unless $source->{$request};


GetOptions( 'type=s', \$type,
		    'build!', \$build,
			'verbose', \$verbose,
		  );

my $package = "Foswiki::Contrib::DockerContrib::$source->{$request}";

my $dc = $package->new( ( port => Net::EmptyPort::empty_port(),
						  verbose => $verbose
						)
					  );

$dc->show($build, $type);

$dc->getUpdateRepo();

$dc->build() if $build;

$dc->start( $type );

$dc->postInstall();

print STDERR "\nStart at: http://localhost:$dc->{port}\n";



