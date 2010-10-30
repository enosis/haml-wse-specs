#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-04.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-04.t
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
$tname = "ImplNotes Code 8.8-04 - Normalizing - Dynamic vars, Folding Inline plus Nesting - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
.quux
  - strvar = "foobar"
  %p
    = strvar
  - strvar = "foo\nbar"
  %p
    = strvar
  - strvar = "foo\nbar"
  %p= strvar
  - strvar = "foo\nbar"
  %p eggs #{strvar} spam
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
  <p>
    foobar
  </p>
  <p>
    foo
    bar
  </p>
  <p>foo
    bar
  </p>
  <p>eggs foo
    bar spam
  </p>
</div>
HTML
#WSE Haml:
#  First case:  Always nest my var's content
#  Second case: Nest my var's content, and normalize just like would otherwise
#  Third case:  Differs from Legacy Haml
#               Start my var's content inline; normalize just like other indents...but:
#               (but: if in option:preserve or option:preformatted, use those indent rules)
#  Fourth case: Differs from Legacy Haml (see prior spec)
#               Start my var's content inline; normalize just like other indents...but:
#               (but: if in option:preserve or option:preformatted, use those indent rules)
#Legacy Haml:
#<div class='quux'>
#  <p>\n    foobar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    eggs foo\n    bar spam\n  </p>
#</div>
}#TODO>>>>>

