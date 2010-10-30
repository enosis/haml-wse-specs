#!/usr/bin/env perl
#
#00ImplNotes_Code07-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_7
#          ./perl $ perl t/00ImplNotes_Code07-02.t
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
$tname = "ImplNotes Code 7-02: WSE In Brief - Irregular UNDENT - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%div
    %p cblock2
       cblock4 nested
    %p cblock3
  %p cblock4
HAML
is($htmloutput, <<'HTML', $tname);
<div>
  <p>cblock2
    cblock4 nested
  </p>
  <p>cblock3</p>
  <p>cblock4</p>
</div>
HTML
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml: Conceptually after modification to Code 7-01
# Under oir:loose, Offside controls Content Block memberships
#   i.o.w: Within an Element, undents can be irregular/arbitrary
# So, "%p cblock4" is a sibling to "%p cblock2" and "%p cblock3"
}#TODO>>>>>

