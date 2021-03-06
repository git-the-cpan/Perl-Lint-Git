#!perl

# Note: cannot use -T here, Git::Repository uses environment variables directly.

use strict;
use warnings;

use Data::Dumper;
use Perl::Lint::Git;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::Git;
use Test::More;


# Check there is a git binary available, or skip all.
has_git();
plan( tests => 7 );

# Retrieve the path to the test git repository.
ok(
	open( my $persistent, '<', 't/test_information' ),
	'Retrieve the persistent test information.',
) || diag( "Error: $!" );
ok(
	defined( my $work_tree = <$persistent> ),
	'Retrieve the path to the test git repository.',
);

# Prepare Perl::Lint::Git.
my $git_linter;
lives_ok(
	sub
	{
		$git_linter = Perl::Lint::Git->new(
			file   => $work_tree . '/test.pl',
		);
	},
	'Create a Perl::Lint::Git object.',
);

# Tests retrieving git blame lines.
my $blame_lines;
lives_ok(
	sub
	{
		$blame_lines = $git_linter->get_blame_lines();
	},
	'Retrieve git blame lines.',
);
isa_ok(
	$blame_lines,
	'ARRAY',
	'$blame_lines',
);
is(
	scalar( @$blame_lines ),
	11,
	'Find 11 lines with corresponding blame information.',
);
subtest(
	'The arrayref of git blame lines is made of Git::Repository::Blame::Line objects.',
	sub
	{
		plan( tests => 11 );
		foreach my $blame_line ( @$blame_lines )
		{
			isa_ok(
				$blame_line,
				'Git::Repository::Plugin::Blame::Line',
				'$blame_line',
			);
		}
	}
);
