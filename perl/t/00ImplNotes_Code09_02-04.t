#!/usr/bin/env perl
#
#00ImplNotes_Code09_02-04.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_2
#          ./perl $ perl t/00ImplNotes_Code09_02-04.t
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
$tname = "ImplNotes Code 9.2-04 - Heads:HamlComment: Mixed Content - Problematic - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
.tutu
    %esku
      %skulist
        %scat Lights
                   %sid 20301
               -#%sname Spot2
                 %sname Spot3
                %sdescr Follow spotlight
        %scat Sound
                   %sid 20304
                 %sname Amplifier
                %sdescr 60watt reverb
HAML
is($htmloutput, <<'HTML', $tname);
<div class='tutu'>
  <esku>
    <skulist>
      <scat>Lights
        <sid>20301</sid>
        <sname>Spot3</sname>
        <sdescr>Follow spotlight</sdescr>
      <scat>Sound
        <sid>20304</sid>
        <sname>Amplifier</sname>
        <sdescr>60watt reverb</sdescr>
      </scat>
    </skulist>
  </esku>
</div>
HTML
#WSE Haml: We'd prefer this, where Haml Comment
# is _either_ Inline _or_ Nested,  but WSE Haml can't go that far, probably.
# So instead both of the snames and the sdescr are scooped up into the 
# HamlComment. Solution is similar to what authors must do under 
# Legacy Haml ... see next RSpec.
}#TODO>>>>>

