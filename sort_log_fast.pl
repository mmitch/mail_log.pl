#!/usr/bin/perl -w
#############################################################################
#
#   sort_log_fast.pl  v0.0.5  2000-07-29
#   This program is part of the mail_log package.
#   It reads a log in common or combined log file format and sorts it
#   by date. It is about 4 times faster than sort_log.pl because it
#   uses the Date::Manip module.
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
# 2000/07/25 -> using Date::Manip instead of external date(1) command, being
#               about 4 times faster than before
# 2000/07/25 -> copy base: sort_log.pl
#
#############################################################################

use strict;
use Date::Manip;

my $cut_cmd  = "/usr/bin/cut";    #   <<<   you might have to edit this
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
    $date = &UnixDate($date,"%q");
    if ((defined $date) and ($date ne "")) {
	print FILTER "$date\t$line\n";
    } else {
	warn "Error while converting date, skipping record #$.\n";
    }
}

close FILTER or die $!;
