#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-06.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-06.t
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
$tname = "ImplNotes Code 8.8-06 - Normalizing - Dynamic var, Folded; Initial Wspc Inline plus Nested - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML', 'strvar' => "  foo\n   bar");
.quux
  %p= strvar
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
  <p>  foo
       bar
  </p>
</div>
HTML
#WSE Haml (this case):
#<div class='quux'>\n  <p>  foo\n       bar\n  </p>\n</div>
#Legacy (prior case - Code08_8-05):
#<div class='quux'>\n  <p>\n      foo\n       bar\n  </p>\n</div>
}#TODO>>>>>

