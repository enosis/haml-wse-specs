#!/usr/bin/env perl
#
#00ImplNotes_Code09_03-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_3
#          ./perl $ perl t/00ImplNotes_Code09_03-01.t
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
$tname = "ImplNotes Code 9.3-01 - Heads:HamlComment: Producing well-formed Html - nested comment - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
.zork
  %p para1
  / plaintext html comment
  %p para2
  /
    nested commenting line1
    / nested commenting line2
  %p para3
HAML
is($htmloutput, <<'HTML', $tname);
<div class='zork'>
  <p>para1</p>
  <!-- plaintext html comment -->
  <p>para2</p>
  <!--
    nested commenting line1
    / nested commenting line2
  <p>para3</p>
</div>
HTML
#Legacy Haml:
#<div class='zork'>
#  <p>para1</p>
#  <!-- plaintext html comment -->
#  <p>para2</p>
#  <!--
#    nested commenting line1
#    <!-- nested commenting line2 -->
#  -->
#  <p>para3</p>
#</div>
}#TODO>>>>>

