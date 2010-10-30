#!/usr/bin/env perl
#
#00ImplNotes_Code08_4-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_4
#          ./perl $ perl t/00ImplNotes_Code08_4-02.t
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
$tname = "ImplNotes Code 8.4-02:- Indentation - Standard Legacy multiblock indent and undent";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%div
  %div#id1
    %p cblock1
    %div#a
      %p cblock2
      %p
        cblock3
  %div#id2
    %p cblock4
HAML
is($htmloutput, <<'HTML', $tname);
<div>
  <div id='id1'>
    <p>cblock1</p>
    <div id='a'>
      <p>cblock2</p>
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
#Legacy Haml
#Compare with next spec, Code 8.4-03, which has variable indentation,
#  and the following specs

