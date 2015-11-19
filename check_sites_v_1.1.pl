#!/usr/bin/perl -w
use strict;
open (INFILE, "<sites_to_check_ssl") or die "could not open input file";
while (defined(my $line=<INFILE>))
{
	$line =~ s/[\r\n]//g;
	my ($server,$service)=split("\t\t*",$line);
	printf "service		: %s\n", $service;
	printf "server 		: %s\n", $server;
	my $port=443;
	my $ssl=`openssl s_client -connect '$server':'$port' < /dev/null 2>/dev/null     | openssl x509 -text -in /dev/stdin`;
        my $valid_until;
	my $algorithm;
	foreach my $ssl_line (split ("\n", $ssl))
	{
		$ssl_line =~ s/^ *//;
		if      ($ssl_line =~ /^not after/i)
		{
			$valid_until = $ssl_line; $valid_until =~ s/Not After : //;
		}
		elsif	($ssl_line =~ /^Signature Algorithm/i)
		{
                        $algorithm   = $ssl_line; $algorithm =~ s/Signature Algorithm: //;		
		}
	}	
printf "Valid until     : %s\n", $valid_until;
printf "Algorithm	: %s\n", $algorithm;	
printf "\n"
}






#openssl s_client -connect "$domain":"$port" < /dev/null 2>/dev/null     | openssl x509 -text -in /dev/stdin | grep "Signature Algorithm"
#openssl s_client -connect "$domain":"$port" < /dev/null 2>/dev/null     | openssl x509 -text -in /dev/stdin | grep "Not After"

