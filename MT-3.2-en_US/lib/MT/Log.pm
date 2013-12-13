# Copyright 2001-2005 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id: Log.pm 15432 2005-07-29 20:41:11Z bchoate $

package MT::Log;
use strict;

use MT::Object;
@MT::Log::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'message' => 'string(255)',
        'ip' => 'string(16)',
        'blog_id' => 'integer not null'
    },
    indexes => {
        created_on => 1,
        blog_id => 1,
    },
    defaults => {
        blog_id => 0,
    },
    datasource => 'log',
    audit => 1,
    primary_key => 'id',
});

sub init {
    my $log = shift;
    $log->SUPER::init(@_);
    my @ts = gmtime(time);
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    $log->created_on($ts);
    $log;
}

1;
__END__

=head1 NAME

MT::Log - Movable Type activity log record

=head1 SYNOPSIS

    use MT::Log;
    my $log = MT::Log->new;
    $log->message('This is a message in the activity log.');
    $log->save
        or die $log->errstr;

=head1 DESCRIPTION

An I<MT::Log> object represents a record in the Movable Type activity log.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Log> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Log> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the log record.

=item * message

The log entry.

=item * ip

The IP address related with the message; this is useful, for example, when
the message pertains to a failed login, to determine the IP address of the
user who attempted to log in.

=item * created_on

The timestamp denoting when the log record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the log record was last modified, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
