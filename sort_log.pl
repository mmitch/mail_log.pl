#!/usr/bin/perl -w
#############################################################################
#
#   sort_log.pl  v0.0.5  2000-07-29
#   This program is part of the mail_log package.
#   It reads a log in common or combined log file format and sorts it
#   by date.
#
#   Copyright (C) 2000  Christian Garbs <mitch@uni.de>
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
#
#############################################################################
#
# 2000/04/24 -> checking return code of $date_cmd call
# 2000/04/23 -> changed C-style || to Perl-style or
# 2000/04/20 -> sort of log file sourced out into this script
#
#############################################################################

use strict;

my $cut_cmd  = "/usr/bin/cut";    #   <<<   you might have to edit this
my $date_cmd = "/bin/date";       #   <<<   you might have to edit this
my $sort_cmd = "/usr/bin/sort";   #   <<<   you might have to edit this

open FILTER, "|$sort_cmd|$cut_cmd -f 2-" or die $!;

# first munch the headers
while (my $line=<STDIN>) { 
    chomp $line;
    my $date = $line;
    $date =~ s/^[^\s]+\s[^\s]+\s[^\s]+\s\[//;
    $date =~ s/\]\s\"GET\s.*$//;
    $date =~ s/\// /g;
    $date =~ s/:/ /;
    $date = `$date_cmd -u +%Y%m%d%H%M%S -d \"$date\" 2> /dev/null`;
    chomp $date;
    if (($? >> 8) or ($date eq "")) {
	warn "Error while converting date, skipping record #$.\n";
    } else {
	print FILTER "$date\t$line\n";
    }
}

close FILTER or die $!;
