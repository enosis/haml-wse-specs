#!/usr/bin/env perl
#
#00ImplNotes_Code07-03.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_7
#          ./perl $ perl t/00ImplNotes_Code07-03.t
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
$tname = "ImplNotes Code 7-03: WSE In Brief - Inline with Newlines - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML', strvar => "foo\nbar" );
.quux
  %p
    = strvar
  %p= strvar
  %p eggs #{strvar} spam
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
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
#Legacy Haml:
#<div class='quux'>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    eggs foo\n    bar spam\n  </p>
#</div>
#
#The prior spec (Code07-02) shows the extension of Mixed Content
#  to a full ContentModel.
#That example shows the Inline portion of the Content rendered
#  immediately after any Html start tag.
#
#But, a related consequence is the rendering of an Inline Content
#ContentBlock having newlines: the initial whitespace, and the
#initial text is rendered immediately after any Html start tag.
}#TODO>>>>>

