#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-09.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-09.t
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


#================================================================
$tname = "ImplNotes Code 8.8-09 - Normalizing - Html Endtag, Preserve tag, Preserved - Legacy Haml ";
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
  <code>foo&#x000A;   bar</code>
</div>
HTML
#Legacy Haml: Drops the trailing newlines
#WSE Haml (next spec Code 8.8-10): consolidates the trailing newlines, then transforms
#<div class='quux'>
#  <code>   foo&#x000A;   bar  &#x000A;</code>
#</div>

