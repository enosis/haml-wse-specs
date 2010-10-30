#!/usr/bin/env perl
#
#00ImplNotes_Code09_05-06.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_5
#          ./perl $ perl t/00ImplNotes_Code09_05-06.t
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
$tname = "ImplNotes Code 9.5-06 - Heads:HereDoc - Case: Textline Following HereDoc Term - Undented - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%body
  %dir
    %dir#d1
      %vtag#n1<<-DOC
     HereDoc Para
  DOC
    %p#n2 para2
HAML
is($htmloutput, <<'HTML', $tname);
<body>
  <dir>
    <dir id='d1'>
      <vtag id='n1'>
     HereDoc Para
      </vtag>
    </dir>
    <p id='n2'>para2</p>
  </dir>
</body>
HTML
#WSE Haml: tag "%p#n2" is a sibling to "%dir#d1"
#  The reference is the "%vtag#n1" Head, not the "DOC" delimiter.
}#TODO>>>>>

