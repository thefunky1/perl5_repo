#!/usr/bin/perl

use DBI;
use strict;

# connect to database
my $driver   = "SQLite";
my $database = "test.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
   or die $DBI::errstr;
print "Opened database successfully\n";

# generate sql statement to insert 1st record
my $stmt = qq(INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
               VALUES (1, 'Paul', 32, 'California', 20000.00 ));

# execute sql statement
my $rv = $dbh->do($stmt) or die $DBI::errstr;

# insert 2nd record
$stmt = qq(INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
               VALUES (2, 'Allen', 25, 'Texas', 15000.00 ));
$rv = $dbh->do($stmt) or die $DBI::errstr;

# insert 3rd record
$stmt = qq(INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
               VALUES (3, 'Teddy', 23, 'Norway', 20000.00 ));

$rv = $dbh->do($stmt) or die $DBI::errstr;

# insert 4th record
$stmt = qq(INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
               VALUES (4, 'Mark', 25, 'Rich-Mond ', 65000.00 ););

$rv = $dbh->do($stmt) or die $DBI::errstr;

print "Records created successfully\n";
$dbh->disconnect();
