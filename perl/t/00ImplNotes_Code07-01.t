#!/usr/bin/env perl
#
#00ImplNotes_Code07-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_7
#          ./perl $ perl t/00ImplNotes_Code07-01.t
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
$tname = "ImplNotes Code 7-01: WSE In Brief - Varying indent and nesting - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%div#id1
    %p cblock2
    %p cblock3
%div#id2
  %p cblock4
       cblock4 nested
HAML
is($htmloutput, <<'HTML', $tname);
<div id='id1'>
  <p>cblock2</p>
  <p>cblock3</p>
</div>
<div id='id2'>
  <p>cblock4
    cblock4 nested
  </p>
</div>
HTML
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml:
# 1. oir:loose, but does not violate oir:strict (each Element undent is 'regular')
# 2. #id1: The indentation for p.cblock2 and p.cblock3 is one IndentStep (4 spaces)
# 3. #id2: The indentation for p.cblock4 is one IndentStep (2 spaces)
#    (in WSE Haml, each Element's immediate ContactBlock can have its own IndentStep)
# 4. #id2: The indentation of "cblock4 nested" is one IndentStep beyond "%p cblock4"
#    this makes it part of a Mixed contentblock to %p
#        "cblock4 nested" could be plaintext or tag; and multiple lines
#    HtmlOutput for this gives "cblock4" tight to the opening tag,
#        and "cblock4 nested" indented by a further OutputIndent.
}#TODO>>>>>

