#!/usr/bin/env perl
#
#00ImplNotes_Code03-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_3
#          ./perl $ perl t/00ImplNotes_Code03-01.t
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
$tname = "ImplNotes Code 3-01: Shiny Things - gee whiz";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%gee
  %whiz
    Wow this is cool!
HAML
is($htmloutput, <<'HTML', $tname);
<gee>
  <whiz>
    Wow this is cool!
  </whiz>
</gee>
HTML

