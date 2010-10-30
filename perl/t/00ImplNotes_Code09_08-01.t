#!/usr/bin/env perl
#
#00ImplNotes_Code09_08-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_8
#          ./perl $ perl t/00ImplNotes_Code09_08-01.t
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
$tname = "ImplNotes Code 9.8-01 - Heads:Tilde, Basic examples - html_escape:true - WSE Haml";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
  ~ "Foo\n<pre>Bar\nBaz</pre>"
HAML
is($htmloutput, <<'HTML', $tname);
<zot>
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
</zot>
HTML
#Legacy Haml: Notice the Tilde ~ operator didn't transform the \n
#    (and the FAP operator, escaped the fresh encoding of \n)
#<zot>
#  Foo\n  &lt;pre&gt;Bar&amp;#x000A;Baz&lt;/pre&gt;
#  Foo\n  &lt;pre&gt;Bar\n  Baz&lt;/pre&gt;
#</zot>
#Legacy Haml:
# Besides the \n bug, there's an inconsistency in whitespace normalization:
#   Why should tilde ~ insert that two-space OutputIndent to align the Baz?
#   a. Actually, at all (given <pre> is option:preserve), and
#   b. When FAP does not also do such alignment/insert (even with newline transform)?
# WSE Haml assumes the two should give same result ... the FAP result.
}#TODO>>>>>

