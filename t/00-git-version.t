#!perl

use strict;
use warnings;

use Git::Repository;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::Git;
use Test::More;


has_git();

plan( tests => 1 );

lives_ok(
	sub
	{
		my $git_version = Git::Repository->version();
		diag( "Testing with git $git_version." );
	},
	'Retrieve git version.',
);
