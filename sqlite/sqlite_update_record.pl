#!/usr/bin/perl

use DBI;
use strict;

my $driver   = "SQLite";
my $database = "test.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
   or die $DBI::errstr;
print "Opened database successfully\n";

# retrieve records
display_records($dbh);

# update records
my $stmt = qq(UPDATE COMPANY set SALARY = 25000.00 where ID=1;);
my $rv = $dbh->do($stmt) or die $DBI::errstr;

if( $rv < 0 ) {
   print $DBI::errstr;
} else {
   print "Total number of rows updated : $rv\n";
   print "############\n";
}

# retrieve records
display_records($dbh);

# update record that does not exist
$stmt = qq(UPDATE COMPANY set SALARY = 25000.00 where ID=6;);
$rv = $dbh->do($stmt) or die $DBI::errstr;

if( $rv < 0 ) {
   print $DBI::errstr;
} else {
   print "Total number of rows updated : $rv\n";
   print "############\n";
}

# retrieve records
display_records($dbh);

print "Operation done successfully\n";
$dbh->disconnect();

sub display_records{
	my $dbh = shift;
	my $stmt = qq(SELECT id, name, address, salary from COMPANY;);
	my $sth = $dbh->prepare( $stmt );
	my $rv = $sth->execute() or die $DBI::errstr;

	if($rv < 0) {
	   print $DBI::errstr;
	}

	while(my @row = $sth->fetchrow_array()) {
		  print "ID = ". $row[0] . "\n";
		  print "NAME = ". $row[1] ."\n";
		  print "ADDRESS = ". $row[2] ."\n";
		  print "SALARY =  ". $row[3] ."\n\n";
	}
}
