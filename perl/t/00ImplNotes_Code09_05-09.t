#!/usr/bin/env perl
#
#00ImplNotes_Code09_05-09.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_5
#          ./perl $ perl t/00ImplNotes_Code09_05-09.t
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
$tname = "ImplNotes Code 9.5-09 - Heads:HereDoc Heads - HereDoc -09- Implementation Notes: TODO: Possible content following term spec, example 1 - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%body
  %dir
    %dir
      %span.red<<-DOC.
     HereDoc Para
     DOC
HAML
is($htmloutput, <<'HTML', $tname);
<body>
  <dir>
    <dir>
      <span class='red'>
        HereDoc Para
      </span>.
    </dir>
  </dir>
</body>
HTML
#TODO: Possible capability, but not included in WSE.
}#TODO>>>>>

