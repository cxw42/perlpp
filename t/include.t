#!/usr/bin/env perl -W
# Tests of < ? :include ? > and < ? :immediate Include ? >
use strict;
use warnings;
use Test::More;
use IPC::Run3;
use constant CMD => 'perl perlpp.pl';

(my $whereami = __FILE__) =~ s/include\.t$//;
my $incfn = '"' . $whereami . 'included.txt"';

my ($in, $out, $err);

my @testcases=(
	# [$in (the script), $out (expected output), $err (stderr output, if any)]
	['<?:include ' . $incfn . ' ?>',"a4b\n"],
		# The newline comes from included.txt, which ends with a newline
	['Hello, <?:include ' . $incfn . ' ?>!',"Hello, a4b\n!"],
	['<?:macro Include ' . $incfn . ' ?>',"a4b\n"],
	['Hello, <?:macro Include ' . $incfn . ' ?>!',"Hello, a4b\n!"],
	['<?:immediate ProcessFile ' . $incfn . ' ?>',"a4b\n"],
	['Hello, <?:immediate ProcessFile ' . $incfn . ' ?>!',"Hello, a4b\n!"],
	['<?:immediate for my $fn (qw(a b c)) { ' .
		'ProcessFile "' . $whereami . '" . $fn . ".txt"; } ?>', "a\nb\nc\n"],
	['<?:macro for my $fn (qw(a b c)) { ' .
		'Include "' . $whereami . '" . $fn . ".txt"; } ?>', "a\nb\nc\n"],
); #@testcases

plan tests => scalar @testcases;
	# thanks to http://edumaven.com/test-automation-using-perl/test-calculated-plan

for my $lrTest (@testcases) {
	my ($testin, $refout, $referr) = @$lrTest;
	run3 CMD, \$testin, \$out, \$err;
	if(defined $refout) {
		is($out, $refout);
	}
	if(defined $referr) {
		is($err, $referr);
	}

} # foreach test

# vi: set ts=4 sts=0 sw=4 noet ai: #

