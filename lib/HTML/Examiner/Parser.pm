####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package HTML::Examiner::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "lib/HTML/Examiner/Parser.yp"

=head1 NAME

HTML::Examiner::Parser - this module implements the parser

=head1 VERSION

Version 0.01_1

=cut

our $VERSION = '0.01_1';

=head1 DESCRIPTION

XXX

=head1 FUNCTIONS

=cut

=head2 new

Create a new parser.

=cut


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'TAG' => 3
		},
		GOTOS => {
			'pattern' => 2,
			'target' => 1,
			'function' => 5,
			'statement' => 4
		}
	},
	{#State 1
		ACTIONS => {
			'VERB' => 6
		},
		DEFAULT => -4,
		GOTOS => {
			'verb' => 7
		}
	},
	{#State 2
		ACTIONS => {
			'ARROW' => 8
		}
	},
	{#State 3
		ACTIONS => {
			'OPEN' => 9
		}
	},
	{#State 4
		DEFAULT => -1
	},
	{#State 5
		ACTIONS => {
			'' => 10
		}
	},
	{#State 6
		DEFAULT => -10
	},
	{#State 7
		ACTIONS => {
			'RE' => 11,
			'PROP' => 12
		},
		GOTOS => {
			'element' => 13
		}
	},
	{#State 8
		ACTIONS => {
			'TYPE' => 15
		},
		GOTOS => {
			'action' => 14
		}
	},
	{#State 9
		ACTIONS => {
			'RE' => 16,
			'NAME' => 17
		},
		GOTOS => {
			'tagname' => 18
		}
	},
	{#State 10
		DEFAULT => 0
	},
	{#State 11
		DEFAULT => -12
	},
	{#State 12
		ACTIONS => {
			'OPEN' => 19
		}
	},
	{#State 13
		DEFAULT => -3
	},
	{#State 14
		DEFAULT => -2
	},
	{#State 15
		ACTIONS => {
			'STR' => 20
		}
	},
	{#State 16
		DEFAULT => -9
	},
	{#State 17
		DEFAULT => -8
	},
	{#State 18
		ACTIONS => {
			'CLOSE' => 21
		}
	},
	{#State 19
		ACTIONS => {
			'NAME' => 22
		}
	},
	{#State 20
		DEFAULT => -13
	},
	{#State 21
		ACTIONS => {
			'DOT' => 23
		},
		DEFAULT => -5
	},
	{#State 22
		ACTIONS => {
			'CLOSE' => 24
		}
	},
	{#State 23
		ACTIONS => {
			'PROP' => 25,
			'CONTENT' => 26
		}
	},
	{#State 24
		DEFAULT => -11
	},
	{#State 25
		ACTIONS => {
			'OPEN' => 27
		}
	},
	{#State 26
		DEFAULT => -6
	},
	{#State 27
		ACTIONS => {
			'NAME' => 28
		}
	},
	{#State 28
		ACTIONS => {
			'CLOSE' => 29
		}
	},
	{#State 29
		DEFAULT => -7
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'function', 1,
sub
#line 31 "lib/HTML/Examiner/Parser.yp"
{ +{function=>$_[1]} }
	],
	[#Rule 2
		 'statement', 3,
sub
#line 34 "lib/HTML/Examiner/Parser.yp"
{ +{pattern=>$_[1],action=>$_[3]} }
	],
	[#Rule 3
		 'pattern', 3,
sub
#line 38 "lib/HTML/Examiner/Parser.yp"
{ +{target=>$_[1],verb=>$_[2],element=>$_[3]} }
	],
	[#Rule 4
		 'pattern', 1,
sub
#line 39 "lib/HTML/Examiner/Parser.yp"
{ +{target=>$_[1]} }
	],
	[#Rule 5
		 'target', 4,
sub
#line 42 "lib/HTML/Examiner/Parser.yp"
{ +{'tag'=>$_[3]} }
	],
	[#Rule 6
		 'target', 6,
sub
#line 43 "lib/HTML/Examiner/Parser.yp"
{ +{tag=>$_[3],content=>$_[6]} }
	],
	[#Rule 7
		 'target', 9,
sub
#line 44 "lib/HTML/Examiner/Parser.yp"
{ +{tag=>$_[3],prop=>$_[8]} }
	],
	[#Rule 8
		 'tagname', 1,
sub
#line 47 "lib/HTML/Examiner/Parser.yp"
{ +{'name'=>$_[1]} }
	],
	[#Rule 9
		 'tagname', 1,
sub
#line 48 "lib/HTML/Examiner/Parser.yp"
{ +{'re'=>$_[1]} }
	],
	[#Rule 10
		 'verb', 1,
sub
#line 51 "lib/HTML/Examiner/Parser.yp"
{ +{verb=>$_[1]} }
	],
	[#Rule 11
		 'element', 4,
sub
#line 54 "lib/HTML/Examiner/Parser.yp"
{ +{prop=>$_[3]} }
	],
	[#Rule 12
		 'element', 1,
sub
#line 55 "lib/HTML/Examiner/Parser.yp"
{ +{re=>$_[1]} }
	],
	[#Rule 13
		 'action', 2,
sub
#line 58 "lib/HTML/Examiner/Parser.yp"
{ +{type=>$_[1],msg=>$_[2]} }
	]
],
                                  @_);
    bless($self,$class);
}

#line 61 "lib/HTML/Examiner/Parser.yp"


=head2 lex

Function used to tokenize source code.

=cut

sub lex {
	my $self = shift;
#print "SOURCE ".$self->{'code'}."\n";

    for ($self->{'code'}) {
        s!^\s+!!;
        ($_ eq '')    and return ('',undef);

        s!^(tag)!!i    and return('TAG',$1);
        s!^(prop)!!i    and return('PROP',$1);
        s!^(error)!!i    and return('TYPE',$1);
        s!^(content)!!i    and return('CONTENT',$1);
        s!^(contains|misses|matches|mismatches)!!i    and return('VERB',$1);
        s!^(\=\>)!!    and return('ARROW',$1);
        s!^(\()!!    and return('OPEN',$1);
        s!^(\))!!    and return('CLOSE',$1);
        s!^(\.)!!    and return('DOT',$1);
        s!^(\w+)!!    and return('NAME',$1);
        #s!^(sub)!!    and return('SUB',$1);
        #s!^\{(.*)\}!!s    and print "|$1|\n" and return('CODE',$1);
        #s!^\{([^{}]*(\{[^{}]*\}[^{}]*)*)\}!!s and return('CODE',$1);

        s!^\"([^\"]+)\"!!    and return('STR',$1);
        s!^/([^/]*)/!!    and return('RE',$1);
    }
}

=head2 yyerror

Function used to report errors.

=cut

sub yyerror {
  if ($_[0]->YYCurtok) {
      printf STDERR ('Error: a "%s" (%s) was found where %s was expected'."\n",
         $_[0]->YYCurtok, $_[0]->YYCurval, $_[0]->YYExpect)
  }
  else { print  STDERR "Expecting one of ",join(", ",$_[0]->YYExpect),"\n";
  }
}

=head2 init_lex

Function used to initialize everything we need.

=cut

sub init_lex {
    my $self = shift;
    $self->{'code'} = shift;

    local $/;
    undef $/;
    #$File = <>
}

# vim: set filetype=perl

1;
