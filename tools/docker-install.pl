use strict;
use warnings;
use Getopt::Long; 

BEGIN {
	unshift @INC, '../lib';
}

use Foswiki::Contrib::DockerContrib::Dieken;
use Foswiki::Contrib::DockerContrib::TimLegge;


my $source = { dieken => 'Dieken',
			   timlegge => 'TimLegge',
			   };
my $request = shift @ARGV;
my $type = 'docker';	#default docker runls tools

my $build = 0; 			# default: no build

exit unless $source->{$request};

my $package = "Foswiki::Contrib::DockerContrib::$source->{$request}";

my $dc = $package->new();

GetOptions( 'type=s', \$type,
		    'build!', \$build );

$dc->show($build, $type);
$DB::single = 1;
$dc->getUpdateRepo()

# $dc->build() if $build;

# $dc->start( $type );


