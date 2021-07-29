#!/usr/bin/env perl
use strict;
use warnings;

my $red = `tput setaf 1` . `tput bold`;
my $gold = `tput setaf 3`;
my $green = `tput setaf 2`;
my $sgr0 = `tput sgr0`;
my $type;

if ( scalar(@ARGV) == 1 ) {
	printf "${red}error:${sgr0} the following required arguments were not provided:\n";
	printf "  ${green}<path>${sgr0}\n";
	printf "\nUSAGE:\n  cargo template <path>\n";
	exit 1;
}

my $arg = $ARGV[1];

if ( $arg eq "--lib" ) {
	$type = "lib";
} elsif ( $arg eq "--bin" ) {
	$type = "bin";
} else {
	printf "${red}error:${sgr0} argument ${gold}${arg}${sgr0} isn't valid in this context\n";
	printf "did you mean: ${green}--lib${sgr0} or ${green}--bin${sgr0}\n";
	exit 1;
}

my $project = $ARGV[2];

my $status = mkdir $project;
if ( $status != 1 ) {
	printf "${red}error:${sgr0} folder ${gold}${project}${sgr0} already exists\n";
	printf "$!";
	exit $!;
}

open(my $ctoml, ">", $project . "/Cargo.toml")
	or die "failed to open a file";

printf $ctoml "cargo-features = [\"edition2021\"]\n\n[package]\nname = \"${project}\"\nversion = \"0.1.0\"\nedition = \"2021\"\nauthors = [\"Aodhnait Étaín <aodhneine\@pm.me>\"]\nlicense = \"0BSD\"\n";

close $ctoml;

mkdir $project . "/src"
	or die "failed to create folder";

if ( $type eq "lib" ) {
	open(my $librs, ">", $project . "/src/lib.rs")
		or die "failed to open file";
	printf $librs "#[cfg(test)]\nmod tests {\n\t#[test]\n\tfn it_works() {\n\t}\n}\n";
} elsif ( $type eq "bin" ) {
	open(my $mainrs, ">", $project . "/src/main.rs")
		or die "failed to open file";
	printf $mainrs "pub fn main() {\n}\n";
	close $mainrs
}

