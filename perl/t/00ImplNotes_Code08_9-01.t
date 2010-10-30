#!/usr/bin/env perl
#
#00ImplNotes_Code08_9-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_9
#          ./perl $ perl t/00ImplNotes_Code08_9-01.t
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
$tname = "ImplNotes Code 8.9-01 - Whitelines - Whiteline Consolidation - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
.quux
    %div
      %p cblock1
      %p

         cblock2a


         cblock2b

         cblock2c


      %p cblock3

      %p cblock4inline
         cblock4a
          -#             # Inserted into Nested Content -- a Haml Comment
           cblock4c      # Captured by Haml Comment as Nested Content ContentBlock

           cblock4d
HAML
is($htmloutput, <<'HTML', $tname);
<div class='quux'>
  <div>
    <p>cblock1</p>
    <p>
      cblock2a

      cblock2b
      cblock2c
    </p>

    <p>cblock3</p>

    <p>
      cblock4inline
      cblock4a
      cblock4d
    </p>
  </div>
</div>
HTML
}#TODO>>>>>

