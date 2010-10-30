#!/usr/bin/env perl
#
#00ImplNotes_Code08_8-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_8
#          ./perl $ perl t/00ImplNotes_Code08_8-02.t
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
$tname = "ImplNotes Code 8.8-02 - Normalizing - Mixed Content - ContentBlock from Multiline Content Block";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%div
  %p
    First line  |
    Second line |
HAML
is($htmloutput, <<'HTML', $tname);
<div>
  <p>First line Second line</p>
</div>
HTML
#Legacy Ruby Haml:
#<div>\n  <p>\n    First line  Second line \n  </p>\n</div>
#WSE Haml:
# Equiv Legacy Haml, with whitespace adjustment
}#TODO>>>>>

