#!/usr/bin/env perl
#
#00ImplNotes_Code09_15-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_15
#          ./perl $ perl t/00ImplNotes_Code09_15-01.t
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
$tname = "ImplNotes Code 9.15-01 - Heads:Whitespace Removal, Simple WSE Haml Mixed Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%bac
  %p Foo
    Bar
    Baz
%saus
  %p= "Thud\nGrunt\nGorp  "
HAML
is($htmloutput, <<'HTML', $tname);
<bac>
  <p>Foo
    Bar
    Baz
  </p>
</bac>
<saus>
  <p>Thud
    Grunt
    Gorp
  </p>
</saus>
HTML
# Removing the Inline Content from the Mixed Content block (WSE Haml-required)
# Legacy gives the following alignments:
# <p>
#   Bar
#   Baz
# </p>
#
# <p>
#   Thud
#   Grunt
#   Gorp
# </p>
}#TODO>>>>>

