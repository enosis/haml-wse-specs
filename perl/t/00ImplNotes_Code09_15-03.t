#!/usr/bin/env perl
#
#00ImplNotes_Code09_15-03.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_15
#          ./perl $ perl t/00ImplNotes_Code09_15-03.t
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
$tname = "ImplNotes Code 9.15-03 - Heads:Whitespace Removal, Trim_out Alignment - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
  %out
    %div>
      %in
        Foo!
HAML
is($htmloutput, <<'HTML', $tname);
<p>
  <out><div>
      <in>
        Foo!
      </in>
  </div></out>
</p>
HTML
#Legacy:
#  <out><div>
#      <in>
#        Foo!
#      </in>
#    </div></out>

