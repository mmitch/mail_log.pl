#!/usr/bin/perl -w
#############################################################################
#
#   lowercase_log.pl  v0.0.5  2000-07-29
#   This program is part of the mail_log package.
#   It reads a log in common or combined log file format and converts the
#   first field to lower case characters.
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
# 2000/04/22 -> new part of the mail_log package
#
#############################################################################

use strict;

while (my $line=<STDIN>) {
    my ($host, $more) = split / /, $line, 2;
    $host = lc $host;
    print "$host $more";
}
