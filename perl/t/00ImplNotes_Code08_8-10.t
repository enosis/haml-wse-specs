#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-10.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-10.t
#
#Authors:x
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
$tname = "ImplNotes Code 8.8-10 - Normalizing - Html Endtag, Preserve Tag, Preserved - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
.quux
  - strvar = "   foo\n   bar  \n\n"
  %code= strvar
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
  <code>   foo&#x000A;   bar  &#x000A;</code>
</div>
HTML
#WSE Haml: Consolidates the trailing newlines, then transforms
#Legacy Haml (previous spec Code 8.8-09) -- Drops trailing newlines
#<div class='quux'>
#  <code>foo&#x000A;   bar</code>
#</div>
}#TODO>>>>>

