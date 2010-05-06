package HTML::Examiner;

use warnings;
use strict;

use XML::DT;
use HTML::Examiner::Parser;
use HTML::Examiner::DTEngine;
use HTML::Examiner::Templates;

=head1 NAME

HTML::Examiner - verify HTML code using custom defined rules

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01_2';

my $report;

=head1 SYNOPSIS

  use HTML::Examiner;

  my $errors = {
    0 => {
      source => 'tag(img) misses prop(alt) => error "img misses tag";'
    }
  };

  my $examiner = HTML::Examiner->new($errors);
  my $report = $examiner->process($html);

=head1 DESCRIPTION

This module implements an engine to verify HTML code use custom
defined rules. This rules are defined in a Domain Specific Language.
For more documentation on writing rules see HTML::Examiner::Parser
documentation.

This module is *not* intended to perform traditional HTML validations,
use other modules for that purpose. Typically you don't even need
to have a valid HTML document, as long as it can be correctly
parsed by XML::DT.

=head1 METHODS

=head2 new

Create a new examiner instance. Reveices as argument an hash
representing our costum defined error database.

=cut

sub new {
	my($class,$errors) = @_;
	my $self = {};
	$self->{'errors'} = $errors;

	foreach (sort keys %$errors) {
		my $ptree = __parse_rule($self->{'errors'}->{$_}->{'source'});
		$self->{'errors'}->{$_}->{'ptree'} = $ptree;
	}

	bless $self, $class;
}

=head2 examine

Call this method to examine HTML code. The code is passed as an argument.

=cut

sub examine {
	my($self, $html) = @_;

	$report = {};
	foreach (sort keys %{$self->{'errors'}}) {
		my $engine = HTML::Examiner::DTEngine->new($self->{'errors'}->{$_}->{'ptree'});
		$engine->process($html);
	}

	HTML::Examiner::report();
}

=head2 __parse_rule

Method to parse a rule a custom defined rule. You shoulnd't have to
call this method directly.

=cut

sub __parse_rule {
	my $source = shift;

	my $parser = HTML::Examiner::Parser->new;
	$parser->init_lex($source);
	my $ptree = $parser->YYParse(
			yylex => \&HTML::Examiner::Parser::lex,
			yyerror => \&HTML::Examiner::Parser::yyerror
		);

	$ptree;
}

=head2 report

This method is used to feed report information when verifying
custom defined rules.

=cut

sub report {
	my $new = shift;

	defined($new) and $report->{$new}++;

	return [keys %$report];
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
