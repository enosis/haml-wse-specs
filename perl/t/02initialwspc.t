#!/usr/bin/env perl
#
#02initialwspc.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/02initialwspc.t
#          ./perl $ make initialwspc
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

use Test::More tests=>11;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#================================================================
$tname = "02InitialWspc -01- haml_indent - Inline and Nested";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= haml_indent.length
%p
  = haml_indent.length
  More Text
.foo
  %p
    = haml_indent.length
HAML
is($htmloutput, <<HTML, $tname);
<p>2</p>
<p>
  2
  More Text
</p>
<div class='foo'>
  <p>
    4
  </p>
</div>
HTML
#From the operator name you might think this would yield lengths
#wrt HamlSource, as in:
#  "<p>0</p>\n<p>\n  2\n  More Text\n</p>\n"
#Or that it refers to indentation index for the <p> or it's content.
#
#Instead, it is querying an attribute of the buffer instance -- the current
#setting. So as is clear above, it is of utility for one specific operation:
#it returns the string that will be used _when_ OutputIndent is deemed to
#be required ... not necessarily as will actually be used for rendering
#the then-current line to HtmlOutput.
#WSE proposes rename: html_indent


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -02- html_indent alias for haml_indent - Inline and Nested";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_indent.length
%p
  = html_indent.length
  Even More Text
.foo
  %p
    = html_indent.length
HAML
is($htmloutput, <<HTML, $tname);
<p>2</p>
<p>
  2
  Event More Text
</p>
<div class='foo'>
  <p>
    4
  </p>
</div>
HTML
#WSE proposed alias for haml_indent
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -03- html_tabs and html_tabstring WSE proposed functions";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
- foo = html_tabs
- bar = html_tabstring
%p= foo
%p= bar
%p= html_indent.length
- baz = html_tabstring('..')
%dir
  %p
    Nested text
HAML
is($htmloutput, <<HTML, $tname);
<p>1</p>
<p>  </p>
<p>2</p>
<dir>
..<p>
....Nested text
..</p>
</dir>
HTML
#WSE proposed operators (see also tab_up, tab_down, with_tabs)
# html_tabstring is get/set
#The then-current count of "tabs" used for the OutputIndent
#The html_tabstring is the OutputIndentStep, typically = 2 spaces
# html_tabstring * html_tabs = OutputIndent
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -04- :preserve filter - simple 2-space IndentStep - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.txt1
  %p para1
  %p
    :preserve
       This
           is a fish
        of some kind
         never before seen here
  %code
    :preserve
       This
           is a fish
        of some kind
         never before seen here
  %p
    %code= " This\n    is a fish\n of some kind\n  never before seen here"
HAML
is($htmloutput, <<HTML, $tname);
<div class='txt1'>
  <p>para1</p>
  <p>
     This&#x000A;     is a fish&#x000A;  of some kind&#x000A;   never before seen here
  </p>
  <code> This&#x000A;     is a fish&#x000A;  of some kind&#x000A;   never before seen here</code>
  <p>
    <code> This&#x000A;    is a fish&#x000A; of some kind&#x000A;  never before seen here</code>
  </p>
</div>
HTML
#BUG: The nit here, in legacy Haml, does not concern :preserve, but rather
# concerns dropping leading whitespace in =expr. Shown as expected here is
# the WSE Haml correction, for comparison.
#WSE Haml retains the behavior of :preserve of using a 'fixed' indent,
# set by the Element's Head IndentStep, to calculate the initial/leading
# whitespace for the contained contentblock
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -05- :preformated filter - simple 2-space IndentStep - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver', 'vtag' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.txt1
  %p para1
  %p.wspcpre#prfmttd
    :preformatted
       This
           is a fish
        of some kind
         never before seen here
  %vtag
    :preformatted
       This
           is a fish
        of some kind
         never before seen here
  %p
    %vtag= " This\n    is a fish\n of some kind\n  never before seen here"
HAML
is($htmloutput, <<HTML, $tname);
<div class='txt1'>
  <p>para1</p>
  <p id='prfmttd' class='wspcpre'>
     This
         is a fish
      of some kind
        never before seen here
  </p>
  <vtag>
 This
     is a fish
  of some kind
   never before seen here
  </vtag>
  <p>
    <vtag> This&#x000A    is a fish&#x000A  of some kind&#x000A;   never before seen here</vtag>
  </p>
</div>
HTML
#WSE Haml:
#Notice: %vtag is option:preformatted (similar to 'pre')
#Notice: Of course that <p id='prfmttd'> element won't render in the
# UA as 'preformatted' unless the author provides the appropriate CSS.
#See the RSpec for preformatted
}#>>>>>TODO


#================================================================
$tname = "02InitialWspc -06- with tab_up()";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
   ptext
- tab_up(1)
%p
   pt2
   .one
      .two
         %pre= expr1(haml_indent)
%p pt3
%p
   pt4
HAML
is($htmloutput, <<'HTML', $tname);
<p>
  ptext
</p>
  <p>
    pt2
    <div class='one'>
      <div class='two'>
        <pre>__        __</pre>
      </div>
    </div>
  </p>
  <p>pt3</p>
  <p>
    pt4
  </p>
HTML
#haml_indent is counting the number of IndentSteps in
#the HamlSource, i, (here: i=3, at three spaces each) which
#is the multiples of OutputIndentStep (two spaces) to apply.
#For haml_indent, then the result is i=3, plus 1 for tab_up(1),
#4 total. 4 Times 2 = 8. (More rationally: 9 spaces in haml_indent,
#in the HamlSource, and 8 spaces in html_indent, in the HtmlOutput.)
#Also: When WSE Haml, the s/haml_indent/html_indent/g


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -07- with with_tabs()";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
   ptext
%dir
   - with_tabs(3) do
      %p
         SomeText
         %p
            IndentText
            %pre= expr1(html_indent)
         MoreText
         - foo = html_tabs
         %p= foo
%p
   pt2
.blk2
   %p
      = html_indent.length
   - with_tabs(html_indent.length) do
      %p
         SomeText
         %p
            IndentText
            %pre= expr1(html_indent)
         MoreText
         %p EasyText
HAML
is($htmloutput, <<HTML, $tname);
<p>
  ptext
</p>
<dir>
      <p>
        SomeText
        <p>
          IndentText
          <pre>__          __</pre>
        </p>
        MoreText
        <p>3</p>
      </p>
</dir>
<p>
  pt2
</p>
<div class='blk2'>
  <p>
    4
  </p>
    <p>
      SomeText
      <p>
        IndentText
        <pre>__        __</pre>
      </p>
      MoreText
      <p>EasyText</p>
    </p>
</div>
HTML
#Notice that the OutputIndent is, simply, the number given
#times the size of the OutputIndentStep (legacy:2). So, here,
#the <p> in HtmlOutput is at column index 6, and the haml_indent
#expression (WSE Haml: html_indent) is two IndentSteps
#from there, so plus 4 = 10.
}#>>>>>TODO


#================================================================
$tname = "02InitialWspc -08- Tabs as initial whitespace";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<"HAML");
%div
\t\t%p
\t\t\t\tpara1
HAML
is($htmloutput, <<HTML, $tname);
<div>\n  <p>\n    para1\n  </p>\n</div>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -09- Inline expression with newline - initial and leading";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%zot
  %p= "  foo\n   bar"
HAML
is($htmloutput, <<HTML, $tname);
<zot>
  <p>  foo
       bar
  </p>
</zot>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "02InitialWspc -10- Inline expression with newline in local var";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', strvar => "  foo\n   bar");
%spike
  %p para
  %p #{strvar}
HAML
is($htmloutput, <<HTML, $tname);
<spike>
  <p>para</p>
  <p>  foo
       bar
  </p>
</spike>
HTML
}#>>>>>TODO

