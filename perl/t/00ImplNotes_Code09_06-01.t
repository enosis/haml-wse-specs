#!/usr/bin/env perl
#
#00ImplNotes_Code09_06-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_6
#          ./perl $ perl t/00ImplNotes_Code09_06-01.t
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
$tname = "ImplNotes Code 9.6-01 - Heads:Preserve, Starttag-Endtag mechanics - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code', 'ptag' ],
                         preformatted => ['ver', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML', strvar => "toto\ntutu");
.wspcpre
  %snap
    %ptag= "Bar\nBaz"
  %crak
    %ptag #{$strvar}
  %pahp
    %ptag
      :preserve
          def fact(n)  
            (1..n).reduce(1, :*)  
          end  
HAML
is($htmloutput, <<'HTML', $tname);
<div class='wspcpre'>
  <snap>
    <ptag>Bar&#x000A;Baz</ptag>
  </snap>
  <crak>
    <ptag>toto&#x000A;tutu</ptag>
  </crak>
  <pahp>
    <ptag>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end</ptag>
  </pahp>
</div>
HTML
#Notice: Trailing whitespace
#Notice: The OutputIndent for filter:preserve is 2 spaces, the
# difference after the IndentStep is removed. If this were legacy Haml
# the file-global IndentStep would be 2-spaces, leaving 2 spaces.

