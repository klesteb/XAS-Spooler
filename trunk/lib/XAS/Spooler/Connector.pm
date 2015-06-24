package XAS::Spooler::Connector;

our $VERSION = '0.01';

use POE;
use Try::Tiny;
use XAS::Lib::POE::PubSub;

use XAS::Class
  debug      => 0,
  version    => $VERSION,
  base       => 'XAS::Lib::Stomp::POE::Client',
  accessors  => 'events',
  constants  => 'TRUE FALSE ARRAY',
  codec      => 'JSON',
  filesystem => 'File',
  vars => {
    PARAMS => {
      -hostname  => 1,
    }
  }
;

#use Data::Dumper;

# ---------------------------------------------------------------------
# Public Events
# ---------------------------------------------------------------------

sub handle_receipt {
    my ($self, $frame) = @_[OBJECT, ARG0];

    my $alias = $self->alias;
    my ($palias, $filename) = split(';', $frame->header->receipt_id);

    $self->log->debug("$alias: alias = $palias, file = $filename");

    $poe_kernel->post($palias, 'unlink_file', File($filename));

}

sub connection_down {
    my ($self) = $_[OBJECT];

    my $alias = $self->alias;

    $self->log->debug("$alias: entering connection_down()");

    $self->events->publish(
        -event => 'pause_processing'
    );

    $self->log->debug("$alias: leaving connection_down()");

}

sub connection_up {
    my ($self) = $_[OBJECT];

    my $alias = $self->alias;

    $self->log->debug("$alias: entering connection_up()");

    $self->events->publish(
        -event => 'resume_processing'
    );

    $self->log->debug("$alias: leaving connection_up()");

}

sub send_packet {
    my ($self, $palias, $type, $queue, $data, $file) = @_[OBJECT,ARG0..ARG5];

    my $alias = $self->alias;

    try {

        my $message = {
            hostname  => $self->hostname,
            timestamp => time(),
            type      => $type,
            data      => decode($data),
        };

        my $packet = encode($message);

        my $frame = $self->stomp->send(
            -destination => $queue, 
            -data        => $packet, 
            -receipt     => sprintf("%s;%s", $palias, $file),
            -persistent  => 'true'
        );

        $self->log->info("$alias: sending $file to $queue");

        $poe_kernel->call($alias, 'write_data', $frame);

    } catch {

        my $ex = $_;

        $self->log->error("$alias: unable to encode/decode packet, reason: $ex");
        $self->log->debug("$alias: alias = $palias, file = $file");

        $poe_kernel->post($palias, 'unlink_file', File($file));

    };

}

# ---------------------------------------------------------------------
# Public Methods
# ---------------------------------------------------------------------

sub session_initialize {
    my $self = shift;

    my $alias = $self->alias;

    $self->log->debug("$alias: entering session_initialize()");

    $poe_kernel->state('send_packet', $self);

    # walk the chain

    $self->SUPER::session_initialize();

    $self->log->debug("$alias: leaving session_initialize()");

}

# ---------------------------------------------------------------------
# Private Methods
# ---------------------------------------------------------------------

sub init {
    my $class = shift;

    my $self = $class->SUPER::init(@_);

    $self->{events} = XAS::Lib::POE::PubSub->new();

    return $self;

}

1;

__END__

=head1 NAME

XAS::Spooler::Connector - Perl extension for the XAS environment

=head1 SYNOPSIS

  use XAS::Spooler::Connector;

  my $connection = XAS::Spooler::Connector->new(
      -alias           => 'connector',
      -host            => $hostname,
      -port            => $port,
      -retry_reconnect => TRUE,
      -tcp_keepalive   => TRUE,
      -hostname        => $env->host,
  );

=head1 DESCRIPTION

This module use to connect to a message queue server for spoolers. It provides
the necessary events and methods so the Factory can do its job.

=head1 PUBLIC METHODS

=head2 new

This method creates the initial session, setups the scheduling for 
gather_data() and initializes JSON processing. It takes the following
configuration items:

=over

=item B<-processor>

A pointer to the ProcessFactory object.

=item B<-queue>

The name of the queue to send messages to on the message queue server.

=item B<-hostname>

The name of the host that this is running on.

=back

=head1 PUBLIC EVENTS

=head2 connection_down

This event signal that the connection had been dropped, we are just stopping 
the collection of data. This is done by notifing the ProcessFactory that
data collection should stop.

=head2 send_packet

This event will format the data to be sent to the message queue server.

=head1 SEE ALSO

=over 4

=item L<XAS|XAS>

=item L<XAS::Spooler|XAS::Spooler>

=back

=head1 AUTHOR

Kevin L. Esteb, E<lt>kevin@kesteb.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Kevin L. Esteb

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
