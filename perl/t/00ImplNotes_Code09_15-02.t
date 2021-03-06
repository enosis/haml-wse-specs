#!/usr/bin/env perl
#
#00ImplNotes_Code09_15-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_15
#          ./perl $ perl t/00ImplNotes_Code09_15-02.t
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
$tname = "ImplNotes Code 9.15-02 - Heads:Whitespace Removal, Trim_in - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%eggs
  %div
    %p< Foo
      Bar
      Baz
  %p para1
%spam
  %div
    %p<= "  Foo\nBar\nBaz  "
  %p para2
HAML
is($htmloutput, <<'HTML', $tname);
<eggs>
  <div>
    <p>Foo
      Bar
      Baz</p>
  </div>
  <p>para1</p>
</eggs>
<spam>
  <div>
    <p>  Foo
    Bar
    Baz  </p>
  </div>
  <p>para2</p>
</spam>
HTML
}#TODO>>>>>

