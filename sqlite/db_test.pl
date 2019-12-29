#!/usr/bin/perl
use strict;
use warnings;
# use FindBin;                 # locate this script
use FindBin qw($Bin);
use lib "$Bin";  # use the parent directory
use DB::sqlite;

my $driver   = "SQLite";
my $database = "test.db";
my $userid = "Ish";
my $password = "asd";

my $db = new DB::sqlite($driver, $database, $userid, $password);
#  insert record
$db->insert({
   table => "COMPANY",
   fields => {
      id       => 5,
      name     => "Rodrick",
      age      => 49,
      address  => "California",
      salary   => "15999.00",
   },
});

exit;