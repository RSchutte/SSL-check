#!/usr/bin/perl -w
use strict;
open (INFILE, "<sites_to_check_ssl") or die "could not open input file";
open (OUTFILE, ">sites_ssl_checked") or die "could not open output file";
while (defined(my $line=<INFILE>))
{
	$line =~ s/[\r\n]//g;
	my ($server,$service)=split("\t\t*",$line);
	printf OUTFILE "service		: %s\n", $service;
	printf OUTFILE "server 		: %s\n", $server;
	my $port=443;
	my $ssl=`timeout 1 openssl s_client -connect '$server':'$port' < /dev/null 2>/dev/null     | openssl x509 -text -in /dev/stdin 2>&1 `;
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
printf OUTFILE "Valid until     : %s\n", $valid_until if(defined($valid_until));
printf OUTFILE "Algorithm	: %s\n", $algorithm if(defined($algorithm));
printf OUTFILE "\n"

}
close(INFILE);
close(OUTFILE);
