# perl extract_ftse100_tickets.pl > extract_ftse100_tickets
# -*- coding: utf-8 -*-
# perl

# get web page content

use strict;
use warnings;

# use LWP::Simple;
use LWP::UserAgent;

my $ua = new LWP::UserAgent;
$ua->timeout(120);
my $url='https://www.londonstockexchange.com/exchange/prices-and-markets/stocks/indices/constituents-indices.html?index=UKX';
my $request = new HTTP::Request('GET', $url);
my $response = $ua->request($request);
my $content = $response->content();
print $content;
