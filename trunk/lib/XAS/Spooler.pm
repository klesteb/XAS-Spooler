package XAS::Spooler;

use strict;
use warnings FATAL => 'all';

our $VERSION = '0.02';

1;

__END__

=head1 NAME

XAS::Spooler - A set of procedures and modules to interact with message queues

=head1 DESCRIPTION

These modules are used to scan directories. Any files found are processed and
sent to queues on a STOMP based message queue server. 

=head1 SEE ALSO

=over 4

=item L<XAS|XAS>

=item L<XAS::Apps::Spooler::Process|XAS::Apps::Spooler::Process>

=item L<XAS::Spooler::Connector|XAS::Spooler::Connector>

=item L<XAS::Spooler::Processor|XAS::Spooler::Processor>

=back

=head1 AUTHOR

Kevin L. Esteb, E<lt>kevin@kesteb.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Kevin L. Esteb

This is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0. For details, see the full text
of the license at http://www.perlfoundation.org/artistic_license_2_0.

=cut
