#!/usr/bin/env perl
#
#00ImplNotes_Code09_02-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_2
#          ./perl $ perl t/00ImplNotes_Code09_02-02.t
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
$tname = "ImplNotes Code 9.2-02 - Heads:HamlComment: Lexeme Separation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.zork
  %p para1
  -# Text comment
  %p para2
.bork
  %p para1
  -#Text comment
  %p para2
HAML
is($htmloutput, <<'HTML', $tname);
<div class='zork'>
  <p>para1</p>
  <p>para2</p>
</div>
<div class='bork'>
  <p>para1</p>
  <p>para2</p>
</div>
HTML

