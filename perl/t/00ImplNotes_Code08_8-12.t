#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-12.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-12.t
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
$tname = "ImplNotes Code 8.8-12 - Normalizing - Mixed Content Leading Whitespace in Expression - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML', 'strvar' => "   foo\n     bar  \n" );
.quux
  %code= strvar
  %cope= strvar
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
  <code>   foo&#x000A;     bar  &#x000A;</code>
  <cope>   foo
    bar
  </cope>
</div>
HTML
#Notice: For WSE Haml, with non-option:preserve tag <cope>:
# 1. The Inline, with Initial Whitespace follows Code 8.8-04 and Code 8.8-06
# 2. Under oir:loose or oir:strict
#    Only 1 OutputIndentStep (defaulted at 2)
#Legacy:
#<div class='quux'>
#  <code>foo&#x000A;     bar</code>
#  <cope>\n       foo\n         bar\n  </cope>
#</div>
}#TODO>>>>>

