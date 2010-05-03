package HTML::Examiner::Templates;
use base qw( Template::Provider );

use warnings;
use strict;

=head1 NAME

HTML::Examiner::Templates - this module store the templates

=head1 VERSION

Version 0.01_1

=cut

our $VERSION = '0.01_1';

my $templates = {
'tag_contains_prop'=> <<'EOT'
if (defined($v{[% ptree.function.pattern.element.prop %]})) { 
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'src/error_report'=> <<'EOT'
	HTML::Examiner::report("[% msg %]");
EOT
,
'any_contains_prop' => <<'EOT'
if (defined($v{[% ptree.function.pattern.element.prop %]})) { 
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'any_misses_prop' => <<'EOT'
unless (defined($v{[% ptree.function.pattern.element.prop %]})) { 
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'content_matches_re' => <<'EOT'
if ($c =~ /[% ptree.function.pattern.element.re %]/) {
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'content_mismatches_re' => <<'EOT'
if (not($c =~ /[% ptree.function.pattern.element.re %]/)) {
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'prop_matches_re' => <<'EOT'
if (defined($v{[% ptree.function.pattern.target.prop %]}) and ($v{[% ptree.function.pattern.target.prop %]} =~ /[% ptree.function.pattern.element.re %]/)) { 
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
'prop_mismatches_re' => <<'EOT'
if (defined($v{[% ptree.function.pattern.target.prop %]}) and not($v{[% ptree.function.pattern.target.prop %]} =~ /[% ptree.function.pattern.element.re %]/)) { 
    [% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
,
're_contains_prop' => <<'EOT'
if ($q =~ /[% ptree.function.pattern.target.tag.re %]/ and defined($v{[% ptree.function.pattern.element.prop %]})) { 
	push @{$HTML::Examiner::report}, "[% ptree.function.action.msg %]";
}
EOT
,
're_misses_prop' => <<'EOT'
unless ($q =~ /[% ptree.function.pattern.target.tag.re %]/ and defined($v{[% ptree.function.pattern.element.prop %]})) { 
	push @{$HTML::Examiner::report}, "[% ptree.function.action.msg %]";
}
EOT
,
'tag_exists' => <<'EOT'
[% PROCESS src/error_report msg = ptree.function.action.msg %]
EOT
,
'tag_misses_prop' => <<'EOT'
unless (defined($v{[% ptree.function.pattern.element.prop %]})) { 
	[% PROCESS src/error_report msg = ptree.function.action.msg %]
}
EOT
};

sub _template_modified {
    my($self,$path) = @_;
	
	return 1;
}

sub _template_content {
    my($self,$path) = @_;

	$path =~ s#^templates/##;
    $self->debug("get $path") if $self->{DEBUG};
	
	my $data = $templates->{$path};
	my $error = "error: $path not found";
	my $mod_date = 1;

	return $data;
}

1;
