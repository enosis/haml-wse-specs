#!/usr/bin/env perl
#
#06mixedcontent.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/06mixedcontent.t
#          ./perl $ make mixedcontent
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

use Test::More tests=>13;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);



#================================================================
$tname = "06MixedContent -01- Inline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %p Inline content
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>Inline content</p>
</foo>
HTML


#================================================================
$tname = "06MixedContent -02- Nested";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %p
    Nested content
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>
    Nested content
  </p>
</foo>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -03- Inline plus Nested, HtmlOutput Mixed -- the chosen alt";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "Inline content\nNested content" );
%foo
  %p Inline content
    Nested content
%bar
  %p #{varstr}
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>Inline content
    Nested content
  </p>
</foo>
<bar>
  <p>Inline content
    Nested content
  </p>
</bar>
HTML
#Choosing model for rendering Mixed Content: compact, or all nested
#This is less attractive, but it has advantages:
# 1. it better reflects the author input
# 2. which results in better locating in the Html
# 3. and results in less fooling with line numbers in case of maintenance
# 4. But makes it difficult to abide by some arbitrary Html coding standards
#This seems a nice direct way to keep (in HtmlOutput) that compact form,
#  with the Inline line on the tag line.
#Okay, for (a) compactness, (b) limited clean alt, (c) ack. author control,
#  (d) tag sensitivity, (e) parallel to cases with newline:
#  Use this alt: Mixed in HtmlOutput.
}#>>>>>TODO

TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -04- Inline plus Nested, HtmlOutput Nested, discarded alt. rendering -- ISNOT";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "Inline content\nNested content" );
%foo
  %p Inline content
    Nested content
%bar
  %p #{varstr}
HAML
isnt($htmloutput, <<HTML, $tname);
<foo>
  <p>
    Inline content
    Nested content
  </p>
</foo>
<bar>
  <p>
    Inline content
    Nested content
  </p>
</bar>
HTML
#WSE Haml -- Discarded alt for rendering Mixed (and interp/inline w/newline):
# More attractive HtmlOutput
#  and makes it easier to abide by some Html coding standards
#One dis: other methods of author input to achieve compact form in HtmlOutput
# are crufty (i.e., Perl-like) and have undesirable side-effect on endtag
}#>>>>>TODO


#================================================================
$tname = "06MixedContent -05- Hierarchical Nested, Child Nested";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%div
  Nested div content
  %p
    Nested para content
HAML
is($htmloutput, <<HTML, $tname);
<div>
  Nested div content
  <p>
    Nested para content
  </p>
</div>
HTML


#================================================================
$tname = "06MixedContent -06- Hierarchical Nested, Child Nested w/Inline Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%div
  Nested div content
  %p Nested para, Inline content
HAML
is($htmloutput, <<HTML, $tname);
<div>
  Nested div content
  <p>Nested para, Inline content</p>
</div>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -07- Hierarchical Nested, Both Inline Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%div Inline div content
  %p Nested para, Inline content
HAML
is($htmloutput, <<HTML, $tname);
<div>Inline div content
  <p>Nested para, Inline content</p>
</div>
HTML
#Legacy: Fails on %div having Mixed Content
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -08- Hierarchical Nested, Parent Empty, Child Mixed";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%div
  %p Nested para, Inline content
    Nested Content
HAML
is($htmloutput, <<HTML, $tname);
<div>
  <p>Nested para, Inline content
    Nested Content
  </p>
</div>
HTML
#For comparison
#Legacy: Fails in same way as above, for Mixed Content in %p
}#>>>>>TODO


#================================================================
$tname = "06MixedContent -09- Inline plus Nested, HtmlOutput Mixed (CHOSEN) - leading wspc - baseline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %p= "  Inline  "
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <p>  Inline</p>
</baz>
HTML
#Notice:
#Initial wspc: Even tho' for <p> is useless, copied through
#Trailing wspc dropped (non-preserve/non-preformatted)


#================================================================
$tname = "06MixedContent -10- Inline plus Nested, HtmlOutput Mixed (CHOSEN) - leading wspc COPIED in Interpolation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "  Inline  " );
%qux
  %p #{varstr}
HAML
is($htmloutput, <<HTML, $tname);
<qux>
  <p>  Inline</p>
</qux>
HTML
#WSE: Interpolation gives same result here as it would for actual Inline quoted text.


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -11- Inline plus Nested, HtmlOutput Mixed (CHOSEN) - leading wspc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bar
  %p= "  Inline  "
         Nested
HAML
is($htmloutput, <<HTML, $tname);
<bar>
  <p>  Inline
    Nested
  </p>
</bar>
HTML
#Notice:
#Inline: wspc copied through; trailing wspc lost
#Nested: Initial wspc is HamlSource IndentStep,
#    converted to single 'tab' (OutputIndentStep) in HtmlOutput
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "06MixedContent -12- Nested Interpolation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "  Inline  \n       Nested  " );
%tutu
  %p #{varstr}
HAML
is($htmloutput, <<HTML, $tname);
<tutu>
  <p>  Inline
    Nested
  </p>
</tutu>
HTML
#For comparison
#Legacy:
#<tutu>
#  <p>
#      Inline  \n           Nested\n  </p>
#</tutu>
}#>>>>>TODO

