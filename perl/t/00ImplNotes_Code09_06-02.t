#!/usr/bin/env perl
#
#00ImplNotes_Code09_06-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_6
#          ./perl $ perl t/00ImplNotes_Code09_06-02.t
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
$tname = "ImplNotes Code 9.6-02 - Heads:Preserve, starttag-endtag mechanics, for :preformatted - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code', 'ptag'],
                         preformatted => ['ver', 'vtag'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML', strvar => "toto\ntutu");
- html_tabstring('   ')
.wspcpre
  %spqr
    %vtag Dirigo
       Regnat Populus
         Justitia Omnibus
      Esse quam videri
  %snap
    %vtag= "Bar\nBaz"
  %crak
    %vtag #{strvar}
  %pahp
    %vtag
      :preformatted
          def fact(n)  
            (1..n).reduce(1, :*)  
          end  
    %vtag<<ASCII
 o           .'`/
     '      /  (
   O    .-'` ` `'-._      .')
      _/ (o)        '.  .' /
      )       )))     ><  <
      `\  |_\      _.'  '. \
        `-._  _ .-'       `.)
    jgs     `\__\
ASCII
HAML
is($htmloutput, <<'HTML', $tname);
<div class='wspcpre'>
   <spqr>
      <vtag> Dirigo
 Regnat Populus
   Justitia Omnibus
Esse quam videri
      </vtag>
   </spqr>
   <snap>
      <vtag>
Bar
Baz
      </vtag>
   </snap>
   <crak>
      <vtag>
toto
tutu
      </vtag>
   </crak>
   <pahp>
      <vtag>
  def fact(n)  
    (1..n).reduce(1, :*)  
  end  
      </vtag>
   </pahp>
   <vtag>
 o           .'`/
     '      /  (
   O    .-'` ` `'-._      .')
      _/ (o)        '.  .' /
      )       )))     ><  <
      `\  |_\      _.'  '. \
        `-._  _ .-'       `.)
    jgs     `\__\
   </vtag>
</div>
HTML
#Notice: WSE filter:preformatted delivers a ContentBlock with the
# offside whitespace removed: whitespace at and to the right of the
# BOD are preserved.
# While, a simple %vtag will produce a ContentBlock aligned
# to indentation 0.
}#TODO>>>>>

