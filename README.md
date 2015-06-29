XAS Spooler - A spooler for the XAS Environment
===============================================

XAS is a set of modules, procedures and practices to help write
consistent Perl5 code for an operations environment. For the most part,
this follows the Unix tradition of small discrete components that
communicate in well defined ways.

This system is cross platform capable. It will run under Windows as well
as Unix like environments without a code rewrite. This allows you to
write your code once and run it wherever.

Installation of this system is fairly straight forward. You can install
it in the usual Perl fashion or there are build scripts for creating
Debian and RHEL install packages. Please see the included README for
details.

This package provides the modules and procedures to provide a spooler.
The spooler scan directories in $XAS_SPOOL and processes any files found
there. These files are converted to messages and sent to queues on
the Message Queue Server. Once queued, the collector can process them
and store them into the appropriate datastore.

Extended documentation is available at: http://scm.kesteb.us/trac

