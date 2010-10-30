#!/usr/bin/env perl
#
#00ImplNotes_Code09_05-04.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_5
#          ./perl $ perl t/00ImplNotes_Code09_05-04.t
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
$tname = "ImplNotes Code 9.5-04 - Heads:HereDoc - Case:trim_out - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%body
  %dir
    %dir
      %vtag><<-DOC
     HereDoc Para
     DOC
HAML
is($htmloutput, <<'HTML', $tname);
<body>
  <dir>
    <dir><vtag>
     HereDoc Para
    </vtag></dir>
  </dir>
</body>
HTML
#Notice: Also contains WSE adjustment for trim_out alignment of endtags
}#TODO>>>>>

