#!/usr/bin/perl -w
#############################################################################
#
#   mail_log.pl  v0.0.5  2000-07-29
#   Reads a mail (with headers) from stdin and prints a
#   line in common or combined log format to stdout.
#
#   Copyright (C) 2000  Christian Garbs <mitch@cgarbs.de>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#############################################################################
#
# 2000/06/16 -> the "X-Mailer" line (user-agent) is now case insensitive
# 2000/04/24 -> replacing " within subject, referer and user-agent with '
#            -> error messages are now printed to STDERR
# 2000/04/22 -> improved regexp to identify Re:plies
# 2000/04/20 -> support for combined log format
#            -> sort of log file sourced out into another script
# 2000/03/27 -> Empty "Date: " lines are set to the current date
# 2000/03/17 -> log file needs to be sorted by date (ascending!)
#
#############################################################################
# 
# to do:
#
# ? provide locking for people who don't use procmail
#
#############################################################################

use strict;

my $date_cmd="/bin/date";         #   <<<   you might have to edit this

my $type = "";

if (($ARGV[0]) && ($ARGV[0] eq "--clf")) {
    $type = "common";
} else {
    $type = "combined";
}

# standard values
my $host = "-";
my $ident = "-";
my $authuser = "-";
my $date = "-";
my $request = "GET - HTTP/1.1";
my $status = "200";
my $bytes = 0;
my $referer = "";
my $subject ="";
my $agent = "";
my $line = "";
my $common = "";

my $today = `$date_cmd`;
if ($? >> 8) {
    die "Could not get current date";
}

# first munch the headers
while ((defined ($line=<STDIN>)) && ($line ne "\n")) {
    $bytes+=length $line;
    chomp $line;
    if ($line =~ /^From:/) {
	$host=$line; # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do {
	    ($a,$b) = split(/ /,$host,2);
	    if ($a =~ /@/) {
		$host=$a;
	    } elsif ($b =~ /@/) {
		$host=$b;
	    } else {
		$host="-";
	    }
	} while ($host =~ / /);
	$host =~ s/^<//;
	$host =~ s/>$//;
    } elsif ($line =~ /^Date:/) {
	$line =~ s/^Date:.//;
	chomp $line;
	if ($line eq "") {
	    $line=$today;
	}
	$date = `$date_cmd -d \"$line\" +\"[%d/%b/%Y:%T %z]\"`;
	if ($? >> 8) {
	    warn "Could not read date from mail, using current date";
	    $date = `$date_cmd -d \"$today\" +\"[%d/%b/%Y:%T %z]\"`;
	    if ($? >> 8) {
		die "Could not even convert today's date";
	    }
	}
	chomp $date;
    } elsif ($line =~ /^Subject:/) {
	$line =~ s/^Subject:.//;
	$subject = $line;
	$line =~ s/ /_/g;
	$line =~ s/"/'/g;
	$request = "GET " . $line . " HTTP/1.1";
    } elsif ($line =~ /^X-Mailer:/i) {
	$agent = $line;
	$agent =~ s/"/'/g;
	$agent =~ s/^X-Mailer:.//i;
    }
}

$bytes+=1;

# then munch the body
while ($line=<STDIN>) {
    $bytes+=length $line;
}

# now print the log record
print "$host $ident $authuser $date \"$request\" $status $bytes";

if ($type eq "combined") {
    # Is this a reply? If yes, then set the Referer
    # this regexp is from borrowed from the tin newsreader:
    if ($subject =~ /^(R[eE](\^\d+|\[\d\])?|A[wW]|Odp):\s/i) {
	$referer=substr $subject,3;
	$referer =~ s/^\s+//;
	$referer =~ s/\s+$//;
	$referer =~ s/"/'/g;
    }
    print " \"$referer\" \"$agent\"";
}

print "\n";
