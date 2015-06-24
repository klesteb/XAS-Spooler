package XAS::Spooler;

use strict;
use warnings FATAL => 'all';

our $VERSION = '0.01';

1;

__END__

=head1 NAME

XAS::Spooler - A set of procedures and modules to interact with message queues

=head1 DESCRIPTION

These modules are used to scan directories. Any files found are processed and
sent to queues on a STOMP based message queue server. 

These modules only support the self generated Alerts and the direct logging 
for the logstash logging option. 

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc XAS::Spooler

=head1 SEE ALSO

=over 4

=item L<XAS|XAS>

=back

=head1 AUTHOR

Kevin L. Esteb, E<lt>kevin@kesteb.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Kevin L. Esteb

This is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0. For details, see the full text
of the license at http://www.perlfoundation.org/artistic_license_2_0.

=cut
