package Dist::Zilla::Plugin::AddFile::FromFS;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Moose;
with (
        'Dist::Zilla::Role::FileGatherer',
);

has src  => (is => 'rw', required => 1);
has dest => (is => 'rw', required => 1);

use namespace::autoclean;

sub gather_files {
    require Dist::Zilla::File::InMemory;

    my ($self, $arg) = @_;

    $self->log_fatal("Please specify src")  unless $self->src;
    $self->log_fatal("Please specify dest") unless $self->dest;

    my $file = Dist::Zilla::File::InMemory->new(
        name => $self->dest,
        content => do {
            local $/;
            open my($fh), "<", $self->src or
                $self->log_fatal(["Can't open src file at '%s'", $self->src]);
            ~~<$fh>;
        });

    $self->log(["Adding file from %s to %s", $self->src, $self->dest]);
    $self->add_file($file);
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Add file from filesystem

=for Pod::Coverage .+

=head1 SYNOPSIS

In F<dist.ini>:

 [AddFile::FromFS]
 src=/home/ujang/doc/tips.txt
 dest=share/tips.txt

To add more files:

 [AddFile::FromFS / OtherTips]
 src=/home/ujang/doc/othertips.txt
 dest=share/othertips.txt


=head1 DESCRIPTION

Note: this module is still just a quick hack, it currently does not do encoding
or other fancy stuffs. You might want to try L<Dist::Zilla::Plugin::GatherDir>
instead. I keep this module on CPAN because GatherDir currently does not provide
a convenient way to add single files.

This plugin simply adds a file from local filesystem to your build.


=head1 SEE ALSO

L<Dist::Zilla::Plugin::GatherDir>

L<Dist::Zilla::Plugin::GenerateFile>

L<Dist::Zilla::Plugin::AddFile::FromCode>

L<Dist::Zilla::Plugin::AddFile::FromCommand>
