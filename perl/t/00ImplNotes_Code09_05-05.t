#!/usr/bin/env perl
#
#00ImplNotes_Code09_05-05.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_5
#          ./perl $ perl t/00ImplNotes_Code09_05-05.t
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
$tname = "ImplNotes Code 9.5-05 - Heads:HereDoc - Case: Textline Following HereDoc Term - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%body
  %dir
    %dir
      %vtag#n1<<-DOC
     HereDoc Para
     DOC
        %p#n2 para2
HAML
is($htmloutput, <<'HTML', $tname);
<body>
  <dir>
    <dir>
      <vtag id='n1'>
     HereDoc Para
      </vtag>
      <p id='n2'>para2</p>
    </dir>
  </dir>
</body>
HTML
#WSE Haml: tag "%p#n2" must be a sibling to "%vtag#n1" because
#  the latter's tag contentblock is already closed ...  so
#  "%p#n2" cannot append to that tree. Provided it satisfies
#  the applicable OIR, then "%p#n2" must be a sibling.
#  The reference is the "%vtag#n1" Head, not the "DOC" delimiter.
}#TODO>>>>>

