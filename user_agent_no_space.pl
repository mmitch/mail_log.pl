#!/usr/bin/perl -w
#############################################################################
#
#   user_agent_no_space.pl  v0.0.5  2000-07-29
#   This program is part of the mail_log package.
#   It reads a log in combined log file format and converts spaces in the
#   User Agent field to underscores.
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
#
#############################################################################
#
# 2000/11/27 -> multiple whitespaces are converted to a single underscore
# 2000/07/29 -> new part of the mail_log package
#
#############################################################################

use strict;

while (my $in = <STDIN>) {
    chomp $in;
    if ($in =~ /^(.*)(\"[^\"]*?\")$/) {
	$in = $1;
	my $agent = $2;
	$agent =~ s/\s+/_/g;
	print "$in$agent\n";
    } else {
	print "$in\n";
    }
}
