#!/usr/bin/env perl
#
#00ImplNotes_Code09_07-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_7
#          ./perl $ perl t/00ImplNotes_Code09_07-01.t
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
$tname = "ImplNotes Code 9.7-01 - Heads:find_and_preserve, Basic examples";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
  = find_and_preserve("Foo\n%Bar\nBaz")
  = find_and_preserve("Foo\n<xre>Bar\nBaz</xre>")
HAML
is($htmloutput, <<'HTML', $tname);
<zot>
  Foo\n  <pre>Bar&#x000A;Baz</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz</xre>
</zot>
HTML
#Legacy Haml:
#<zot>
#  Foo\n  <pre>Bar&#x000A;Baz</pre>
#  Foo\n  %Bar\n  Baz
#  Foo\n  <xre>Bar\n  Baz</xre>
#</zot>
#In the non-preserving cases (2, 3),
#   those spaces after \n ... should NOT be qty:4 -- 4 would be as if adjusting
#   to align <xre>....</xre> and contents.
#   But each \n segment is actually just text at the same left alignment,
#   as the initial string character, so don't add EXTRA indent
#Note: Because there are no leading or trailing whitespace, the result
#   is the same in WSE Haml

