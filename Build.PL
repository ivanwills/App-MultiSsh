use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name       => 'App::MultiSsh',
	license           => 'perl',
	dist_author       => 'Ivan Wills <ivan.wills@gmail.com>',
	dist_version_from => 'lib/App/MultiSsh.pm',
	requires          => {
		'perl'             => 5.008,
	},
	build_requires => {
		'Test::More'       => 0,
		'Test::NoWarnings' => 0,
	},
	add_to_cleanup     => [ 'App-MultiSsh-*' ],
	create_makefile_pl => 'traditional',
	create_license     => 1,
	meta_merge => {
		resources => {
			repository => 'git://github.com/ivanwills/App-MultiSsh.git',
			bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=App::MultiSsh',
		},
	},
);

$builder->create_build_script();
