#!/usr/bin/env perl
#
#00ImplNotes_Code08_4-03.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_4
#          ./perl $ perl t/00ImplNotes_Code08_4-03.t
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
$tname = "ImplNotes Code 8.4-03: Indentation - Varying indent steps - OIR:strict";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%div
  %div#id1
     %div#a cblock1
     %div#b
         cblock2
         %p
            cblock3
  %div#id2
      %p cblock4
HAML
is($htmloutput, <<'HTML', $tname);
<div>
  <div id='id1'>
    <div id='a'>cblock1</div>
    <div id='b'>
      cblock2
      <p>
        cblock3
      </p>
    </div>
  </div>
  <div id='id2'>
    <p>cblock4</p>
  </div>
</div>
HTML
#WSE Haml - Variable indent, with oir:strict (no irregular undent)
#Compare with specs: previous Code 8.4-02, and next Code 8.4-04, and
#  the following Code 8.4-05 (oir:loose), and Code 8.4-06
}#TODO>>>>>

