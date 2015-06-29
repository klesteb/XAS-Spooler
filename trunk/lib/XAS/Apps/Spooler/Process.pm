package XAS::Apps::Spooler::Process;

our $VERSION = '0.01';

use XAS::Spooler::Connector;
use XAS::Spooler::Processor;

use XAS::Class
  debug     => 0,
  version   => $VERSION,
  base      => 'XAS::Lib::App::Service',
  mixin     => 'XAS::Lib::Mixins::Configs',
  utils     => 'dotid trim',
  accessors => 'host port cfg',
  vars => {
    SERVICE_NAME         => 'XAS_Spooler',
    SERVICE_DISPLAY_NAME => 'XAS Spooler',
    SERVICE_DESCRIPTION  => 'The XAS Spooler',
  }
;

# ----------------------------------------------------------------------
# Public Methods
# ----------------------------------------------------------------------

sub setup {
    my $self = shift;

    my @sections = $self->cfg->Sections();

    foreach my $section (@sections) {

        next if ($section !~ /^spooler:/);

        my ($alias) = $section =~ /^spooler:(.*)/;
        $alias = trim($alias);

        my $processor = XAS::Spooler::Processor->new(
            -connector   => 'connector',
            -alias       => $alias,
            -tasks       => $self->cfg->val($section, 'tasks', 1),
            -queue       => $self->cfg->val($section, 'queue', ''),
            -directory   => $self->cfg->val($section, 'directory', ''),
            -schedule    => $self->cfg->val($section, 'schedule', '*/1 * * * *'),
            -packet_type => $self->cfg->val($section, 'packet-type', 'unknown'),
        );

        $self->service->register($alias);

    }

}

sub main {
    my $self = shift;

    $self->setup();

    my $connector = XAS::Spooler::Connector->new(
        -alias           => 'connector',
        -host            => $self->host,
        -port            => $self->port,
        -tcp_keepalive   => 1,
        -retry_reconnect => 1,
        -hostname        => $self->env->host,
    );

    $self->log->info_msg('startup');

    $self->service->register('connector');
    $self->service->run();

    $self->log->info_msg('shutdown');

}

sub options {
    my $self = shift;

    $self->{host} = $self->env->mqserver;
    $self->{port} = $self->env->mqport;

    return {
        'host=s' => \$self->{host},
        'port=s' => \$self->{port}
    };

}

# ----------------------------------------------------------------------
# Private Methods
# ----------------------------------------------------------------------

sub init {
    my $class = shift;

    my $self = $class->SUPER::init(@_);

    $self->load_config();

    return $self;

}

1;

__END__

=head1 NAME

XAS::Apps::Spooler::Process - Process spool files 

=head1 SYNOPSIS

 use XAS::Apps::Spooler::Process;

 my $app = XAS::Apps::Spooler::Process->new(
     -throws => 'xas-spooler',
 );

 exit $app->run();

=head1 DESCRIPTION

This method will process a set of spoool directories and send the contents
to a STOMP based message queue server.

=head1 METHODS

=head2 setup

=head2 main

=head2 options

=head1 SEE ALSO

=over 4

=item L<XAS|XAS>

=item L<XAS::Spooler|XAS::Spooler>

=back

=head1 AUTHOR

Kevin L. Esteb, E<lt>kevin@kesteb.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 Kevin L. Esteb

This is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0. For details, see the full text
of the license at http://www.perlfoundation.org/artistic_license_2_0.

=cut
