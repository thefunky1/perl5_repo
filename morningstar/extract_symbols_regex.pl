use warnings 'all';
use strict;
use feature qw(say);
use Data::Dumper;

my $path="extract_ftse100_tickets";
my $regex = qr/<td scope="row" class="name">([A-Z0-9.]+)<\/td>/mp;
my @matches;

open my $fh, "<", $path  or die "Can't open $path: $!";
while (my $line = <$fh>)
{
     if ( $line =~ /$regex/g ) { # check for symbol
         push @matches, $1;
     }
    # check for next page
}
say "@matches";
print Dumper @matches;


close $fh;