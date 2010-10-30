#!/usr/bin/env perl
#
#00ImplNotes_Code08_2-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_2
#          ./perl $ perl t/00ImplNotes_Code08_2-02.t
#
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default
#Notice: Trailing whitespace is present on some Textlines

use strict;
use warnings;

use Test::More tests=>2;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}

my ($haml,$tname,$htmloutput);


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "ImplNotes Code 8.2-02: Coarse Hierarchy -- Multiline - Single block after Haml Comment removal";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
  First |
  Block |
  -# Haml Comment    # WSE processing model changes the AST
  Second |
  Block |
HAML
is($htmloutput, <<'HTML', $tname);
<foo>
  First Block Second Block
</foo>
HTML
#Legacy Ruby Haml
#<foo>\n  First Block \n  Second Block \n</foo>
}#TODO>>>>>

