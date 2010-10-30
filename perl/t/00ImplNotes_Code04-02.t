#!/usr/bin/env perl
#
#00ImplNotes_Code04-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_4
#          ./perl $ perl t/00ImplNotes_Code04-02.t
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
$tname = "ImplNotes Code 4-02: Motivation - Nex3 Issue 28 - 1-level indent - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
    %baz
      bang
    boom
HAML
is($htmloutput, <<'HTML', $tname);
<foo>
  <bar>
    <baz>
      bang
    </baz>
    boom
  </bar>
</foo>
HTML
}#TODO>>>>>

