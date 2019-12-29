#!/usr/bin/perl
package DB::sqlite;

use strict;
use warnings;
use DBI;

sub new {
   my $cls_name = shift;
   my $ref = {
      driver   => shift,
      database => shift,
      user     => shift,
      password => shift,
      dbh      => shift,
   };
   bless $ref, $cls_name;
   return $ref;
}

sub connect {
   # todo: add check if already connected to any db
   my $self = shift;
   my $driver   = $self->{driver};
   my $database = $self->{database};
   my $dsn = "DBI:$driver:dbname=$database";
   $self->{dbh} //= DBI->connect($dsn, $self->{userid}, $self->{password}, { RaiseError => 1 }) 
      or die $DBI::errstr;
   print "Connected to database successfully\n";
   return $self->{dbh};
}

sub disconnect {
   my $self = shift;
   # todo: add check if not connected to db
   # use DDP;
   # p $self->{dbh};
   $self->{dbh}->disconnect() or die $DBI::errstr;
   print "Disconnected from database successfully\n";
   undef $self->{dbh};
   # p $self->{dbh};
   return 1;
}

sub insert {
   # my ($class,$args) = @_;
   my ($self, $hr_params) = @_;
   my $s_table_name  = $hr_params->{table};
   my $hr_fields     = $hr_params->{fields};

   $self->connect();

   # my $stmt = qq(INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
   #             VALUES (1, 'Paul', 32, 'California', 20000.00 ));
   my $s_statement   = "INSERT INTO " . uc $s_table_name . " (";
   my $s_values      = "";
   my $i_count       = 1;
   my $i_no_fields   = scalar(keys %{$hr_fields});
   for my $s_field ( keys %{$hr_fields} ) {
      # check for last entry
      if ( $i_count < $i_no_fields ) {
         $s_statement   .= $s_field . ",";
         $s_values      .= "'" . $hr_fields->{$s_field} . "',";
      }
      else {
         $s_statement   .= $s_field;
         $s_values      .= "'" . $hr_fields->{$s_field} . "'";
      }
      $i_count++;
   }
   $s_statement .= ") VALUES ($s_values)";
   print $s_statement . "\n"; # INSERT INTO aTableName (field3,field1,field2) VALUES (3,1,2)
   $self->{dbh}->do($s_statement) or die $DBI::errstr;
   $self->disconnect();

   return;
}

sub update {
   my ($self, $hr_params) = @_;
   return;
}

sub delete {
   my ($self, $hr_params) = @_;
   return;
}

sub create {
   my ($self, $hr_params) = @_;
   return;
}

sub select {
   my ($self, $hr_params) = @_;
   return;
}

sub _dbh {
   my $self = shift;
   
   return $self->{dbh};
}

1;