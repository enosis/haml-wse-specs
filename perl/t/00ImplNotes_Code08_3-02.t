#!/usr/bin/env perl
#
#00ImplNotes_Code08_3-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_8
#       :  ./perl $ make code_8_3
#          ./perl $ perl t/00ImplNotes_Code08_3-02.t
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
$tname = "ImplNotes Code 8.3-02: Elements - Two-line nesting - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%div
  %p
    cblock1
    %span cblock2
HAML
is($htmloutput, <<'HTML', $tname);
<div>
  <p>
    cblock1
    <span>cblock2</span>
  </p>
</div>
HTML
#Legacy Ruby Haml
#<div>\n  <p>\n    cblock1\n    <span>cblock2</span>\n  </p>\n</div>

