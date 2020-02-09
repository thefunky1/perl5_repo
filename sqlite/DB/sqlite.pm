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

   my $s_table_name  = $hr_params->{table};
   my $hr_fields     = $hr_params->{fields};
   my $hr_key        = $hr_params->{keys};

   $self->connect();
#  my $stmt = qq(UPDATE COMPANY set SALARY = 25000.00 where ID=1;);
   my $s_statement   = "UPDATE " . uc $s_table_name . " set ";
   my $s_values      = "";
   my $i_count       = 1;
   my $i_no_fields   = scalar(keys %{$hr_fields});
   # set fields to be updated
   for my $s_field ( keys %{$hr_fields} ) {
      if ( $i_count < $i_no_fields ) {
         $s_statement   .= $s_field . " = '" . $hr_fields->{$s_field} . "', ";
      }
      else { # last entry
         $s_statement   .= $s_field . " = '" . $hr_fields->{$s_field} . "' ";
      }
      $i_count++;
   }

   # set key of records that should be updated
   # from 
   # You can combine N number of conditions using AND or OR operators - todo: implement
   $i_count       = 1;
   $i_no_fields   = scalar(keys %{$hr_key});
   if ( $i_no_fields and $i_no_fields > 0 ) {
      $s_statement .= " WHERE ";
      for my $s_key ( keys %{$hr_key} ) {
         if ( $i_count < $i_no_fields ) {
            $s_statement   .= $s_key . " = '" . $hr_key->{$s_key} . "' AND ";
         }
         else { # last entry
            $s_statement   .= $s_key . " = '" . $hr_key->{$s_key} . "'";
         }
         $i_count++;
      }
   }
   print $s_statement . "\n"; # INSERT INTO aTableName (field3,field1,field2) VALUES (3,1,2)
   $self->{dbh}->do($s_statement) or die $DBI::errstr;
   $self->disconnect();

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
   my $s_table_name  = $hr_params->{table};
   my $ar_columns    = $hr_params->{columns};
   my $hr_where      = $hr_params->{where};

   
   use Data::Dumper;
   print Dumper $s_table_name . "\n";
   print Dumper @$ar_columns  . "\n";
   print Dumper $hr_where . "\n";

   $self->connect();
   # my $stmt = qq(SELECT column1, column2, columnN FROM table_name; ));
   # my $stmt = qq(SELECT * FROM COMPANY; ));
   # my $stmt = qq(SELECT sql FROM sqlite_master WHERE type = 'table' AND tbl_name = 'COMPANY'; ));
   my $s_columns;
   if ( $ar_columns ) {
      my $i_count = 0;
      for my $s_column ( $ar_columns ) {
         # first column
         if ( $i_count == 0 ) {
            $s_columns = $s_column;
            $i_count++;
            next;
         }
         $s_columns .= ", " . $s_column;
      }
   } else {
      $s_columns = "*";
   }
   my $s_statement = "SELECT " . uc $s_columns . " FROM " . uc $s_table_name;
   if ( $hr_where ) {
      my $i_count = 0;
      for my $s_column ( keys %$hr_where ){
         if ( $i_count == 0 ) {
            my $s_statement .= " WHERE " . $s_column . " = '" . $hr_where->{$s_column} . "'";
            $i_count++;
            next;
         }
         $s_statement .= " AND " . $s_column . " = '" . $hr_where->{$s_column} . "'";
      }
   }
   print $s_statement . "\n";
   my $sth = $self->{dbh}->prepare( $s_statement );
   my $rv = $sth->execute() or die $DBI::errstr;
   if($rv < 0) {
      print $DBI::errstr;
   }
   # use DDP;
   my %h_result;
   my $i_count = 0;
   while(my @row = $sth->fetchrow_array()) {
      # p @row;

      # print "ID = ". $row[0] . "\n";
      # print "NAME = ". $row[1] ."\n";
      # print "ADDRESS = ". $row[2] ."\n";
      # print "SALARY =  ". $row[3] ."\n\n";
      $h_result{$i_count} = \@row; # add array as hash reference
      $i_count++;
   }

   # my @row = $sth->fetchrow_array();
   $self->disconnect();

   return %h_result;
}

sub _dbh {
   my $self = shift;
   
   return $self->{dbh};
}

1;