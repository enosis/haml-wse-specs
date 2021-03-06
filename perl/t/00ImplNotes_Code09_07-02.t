#!/usr/bin/env perl
#
#00ImplNotes_Code09_07-02.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_7
#          ./perl $ perl t/00ImplNotes_Code09_07-02.t
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
$tname = "ImplNotes Code 9.7-02 - Heads:find_and_preserve, Basic examples - html_escape:true";
$haml = Text::Haml->new( escape_html => 1,
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
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
  Foo\n  %Bar\n  Baz
  Foo\n  &lt;xre&gt;Bar\n  Baz&lt;/xre&gt;
</zot>
HTML
#Legacy Haml (notice the unexpected transform of \n => &amp;#x000A;:
#<zot>
#  Foo\n  &lt;pre&gt;Bar&amp;#x000A;Baz&lt;/pre&gt;
#  Foo\n  %Bar\n  Baz
#  Foo\n  &lt;xre&gt;Bar\n  Baz&lt;/xre&gt;
#</zot>
}#TODO>>>>>

