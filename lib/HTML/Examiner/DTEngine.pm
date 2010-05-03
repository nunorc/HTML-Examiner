package HTML::Examiner::DTEngine;

use warnings;
use strict;

use XML::DT;
use Template;
use HTML::Examiner::Templates;
use Template::Constants qw( :debug );
use Data::Dumper;

=head1 NAME

HTML::Examiner::DTEngine - The great new HTML::Examiner::DTEngine

=head1 VERSION

Version 0.01_1

=cut

our $VERSION = '0.01_1';

=head1 SYNOPSIS

  use HTML::Examiner::DTEngine;

  my $examiner = HTML::Examiner->new();

=head1 SUBROUTINES/METHODS

=head2 new

Create new module instance.

=cut

sub new {
	my($class,$ptree) = @_;

	my $self = {};
	__proc_rule($self,$ptree);

	bless $self, $class;
}

=head2 process

Process the HTML given as argument with the user defined rules.

=cut

sub process {
	my($self,$html) = @_;

	my %handler = (
		-html => 1,
	);
	$handler{$self->{'tag'}} = eval "sub {".$self->{'code'}." }";

	dtstring($html, %handler);
}

=head2 __proc_rule

Process a single rule, you shouldn't call this method directly.

=cut

sub __proc_rule {
	my($self,$ptree) = @_;

	# handle tag any
	if ($ptree->{'function'}->{'pattern'}->{'target'}->{'tag'}->{'name'} eq 'ANY' or defined($ptree->{'function'}->{'pattern'}->{'target'}->{'tag'}->{'re'}) ) {
		$self->{'tag'} = '-default';
	}
	else {
		$self->{'tag'} = $ptree->{'function'}->{'pattern'}->{'target'}->{'tag'}->{'name'};
	}

	my $template_config = {
			INCLUDE_PATH => [ 'templates' ],
		};

	my $template = Template->new({
        LOAD_TEMPLATES => [ HTML::Examiner::Templates->new($template_config) ],
	});

	my $output;
	my $vars = {};
	$vars->{'ptree'} = $ptree;

	# handle target for template name
	my $template_name = 'tag';
	if (defined($ptree->{'function'}->{'pattern'}->{'target'}->{'prop'})) {
		$template_name = 'prop';
	}
	if (defined($ptree->{'function'}->{'pattern'}->{'target'}->{'content'})) {
		$template_name = 'content';
	}
	if (defined($ptree->{'function'}->{'pattern'}->{'target'}->{'tag'}->{'re'})) {
		$template_name = 're';
	}
	if ($ptree->{'function'}->{'pattern'}->{'target'}->{'tag'}->{'name'} eq 'ANY') {
		$template_name = 'any';
	}

	# handle verb template name
	if (defined($ptree->{'function'}->{'pattern'}->{'verb'}->{'verb'})) {
		$template_name .= '_'.$ptree->{'function'}->{'pattern'}->{'verb'}->{'verb'};
	}
	else {
		$template_name .= '_exists';
	}

	# handle last part of template name
	if (defined($ptree->{'function'}->{'pattern'}->{'element'}->{'prop'})) {
		$template_name .= '_prop';
	}
	if (defined($ptree->{'function'}->{'pattern'}->{'element'}->{'re'})) {
		$template_name .= '_re';
	}

	# process template
	$template->process($template_name, $vars, \$output);
	$self->{'code'} = $output;
}

=head1 AUTHOR

Nuno Carvalho, C<< <smash at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-examiner at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Examiner>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::Examiner


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-Examiner>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-Examiner>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-Examiner>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-Examiner/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Nuno Carvalho.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of HTML::Examiner
