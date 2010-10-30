#!/usr/bin/env perl
#
#01helpers.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/01helpers.t
#          ./perl $ make helpers
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

use Test::More tests=>14;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -01- html_indent - WSE alias for haml_indent";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= haml_indent.length
%p #{haml_indent}
%p abc#{haml_indent}def
%code #{haml_indent}
%ver #{haml_indent}
%p= html_indent.length
%p= uvw#{html_indent}xyz
HAML
is($htmloutput, <<HTML, $tname);
<p>2</p>
<p></p>
<p>abc  def</p>
<code>  </code>
<ver>
</ver>
<p>2</p>
<p>uvw  xyx</p>
HTML
#Notice:
# - haml_indent.length is 2 even though the then-current element will receive
#   no OutputIndent
# - For a non-preserve/non-preformatted tag, the whitespace-only tag in HamlSource
#   is generated as an empty Html element in the HtmlSource
# - For a whitespace-only preserve/preformatted tag, the whitespace is replayed in
#   the HtmlSource. Preserve tags are rendered horizontally; preformatted tags
#   are rendered vertically. An Inline fragment is rendered following the start tag
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -02- capture_html - WSE alias for capture_haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
- foo = capture_haml("Foo\n<atag>bar\nbaz</atag>") do |a|
  %tag= a
.toto
  %div
    #{foo}
- foo = capture_html("Foo\n<atag>bar\nbaz</atag>") do |a|
  %tag= a
.tutu
  %div
    #{foo}
HAML
is($htmloutput, <<HTML, $tname);
<div class='toto'>
  <div>
    <tag>
      Foo
      <atag>bar
      baz</atag>
    </tag>
  </div>
</div>
<div class='tutu'>
  <div>
    <tag>
      Foo
      <atag>bar
      baz</atag>
    </tag>
  </div>
</div>
HTML
#WSE proposed alias for capture_haml
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -03- html_concat - WSE alias for haml_concat";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.foo
  .bar
    - haml_concat("<tag>  fred\nbarney  </tag>")
.baz
  .zot
    - html_concat("<tag>  spam\neggs  </tag>")
HAML
is($htmloutput, <<HTML, $tname);
<div class='foo'>
  <div class='bar'>
    <tag>  fred
    barney  </tag>
  </div>
</div>
<div class='baz'>
  <div class='zot'>
    <tag>  spam
    eggs  </tag>
  </div>
</div>
HTML
#WSE proposed alias for haml_concat
#DocBUG: haml_concat says "outputs text" (meaning param text) directly
# to buffer, with proper indentation
#What is meant: haml_concat inserts into the HtmlOutput buffer a line
# containing param, with proper indentation
#
#Notice: The inserted OutputIndent following the newline
#(Also:Leading and Trailing whitespace is replayed into HtmlOutput)
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -04- html_concat - WSE alias for haml_concat";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%fruit Apples
%vege
  Carrots
  - html_concat(" * " * 2)
  %starch/
HAML
is($htmloutput, <<HTML, $tname);
<fruit>Apples</fruit>
<vege>
  Carrots
   *  * 
  <starch />
</vege>
HTML
#WSE proposed alias for haml_concat
#Notice: html_concat/haml_concat maintains proper indentation
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -05- html_tag - WSE alias for haml_tag";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
- haml_tag :table do
  - haml_tag :tr do
    - haml_tag 'td.cell' do
      - haml_tag :strong, "strong!"
      - haml_concat "data"
- html_tag :table do
  - html_tag :tr do
    - html_tag 'td.cell' do
      - html_tag :strong, "sweet!"
      - html_concat "candy"
HAML
is($htmloutput, <<HTML, $tname);
<table>
  <tr>
    <td class='cell'>
      <strong>strong!</strong>
      data
    </td>
  </tr>
</table>
<table>
  <tr>
    <td class='cell'>
      <strong>sweet!</strong>
      candy
    </td>
  </tr>
</table>
HTML
#WSE proposed alias for haml_tag
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -06- html_tabs - WSE proposed function";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_tabs
.n1
  %p= html_tabs
.n2
  .n2a
    %p= html_tabs
HAML
is($htmloutput, <<HTML, $tname);
<p>1</p>
<div id='n1'>
  <p>1</p>
</div>
<div id='n2'>
  <div id='n2a'>
    <p>2</p>
  </div>
</div>
HTML
#WSE proposed function
#The number of OutputIndentSteps for next indented line
# (aka: haml_buffer.tabulation)
# html_tabstring * html_tabs => html_indent (OutputIndent)
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -07- html_tabstring - WSE proposed get/set function";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_tabstring
- html_tabstring('..')
%p= html_tabstring
%p
  %div#id1
    %p cblock1
    %div#a
      %p cblock2
HAML
is($htmloutput, <<HTML, $tname);
<p>  </p>
<p>..</p>
<p>
..<div id='#id1'>
....<p>cblock2</p>
....<div id='a'>
......<p>cblock2</p>
....</div>
..</div>
</p>
HTML
#WSE proposed function
#The string used for a single OutputIndentStep. Default: "  "
# (aka: '  ' constant buried in helpers.rb "haml_indent")
#
# html_tabstring * html_tabs => html_indent (OutputIndent)
# (html_tabs: aka: haml_buffer.tabulation)
#
#Setter: sets the html_tabstring
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -08- html_escape - WSE enhanced function - escape_html:false";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
is($htmloutput, <<HTML, $tname);
<p>Any &lt; string &amp; data &amp; &apos; apostrophe</p>\n
HTML
#WSE proposed function
#legacy haml: option:escape_html => false
#legacy: "<p>Any &lt; string &amp; data &amp;amp; ' apostrophe</p>\n"
#Below in next test:
#legacy haml: option:escape_html => true
#legacy: "<p>Any &amp;lt; string &amp;amp; data &amp;amp;amp; ' apostrophe</p>\n"
#
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: &apos;
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -09- html_escape - WSE enhanced function - escape_html:true";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
is($htmloutput, <<HTML, $tname);
<p>Any &lt; string &amp; data &amp; &apos; apostrophe</p>\n
HTML
}#>>>>>TODO
#WSE proposed function
#legacy haml: option:escape_html => true
#legacy: "<p>Any &amp;lt; string &amp;amp; data &amp;amp;amp; ' apostrophe</p>\n"
#See above, in prior test:
#legacy haml: option:escape_html => false
#legacy: "<p>Any &lt; string &amp; data &amp;amp; ' apostrophe</p>\n"
#
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: &apos;


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -10- html_escape - WSE enhanced function - escape_html:false, format:html4";
$haml = Text::Haml->new( escape_html => 0, format => 'html4',
                         preserve => [ 'pre', 'textarea', 'coe' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
is($htmloutput, <<'HTML', $tname);
<p>Any &lt; string &amp; data &amp; ' apostrophe</p>
HTML
#WSE proposed function
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: ' &apos;
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -11- escape_html &= escape_once - WSE extended functions - escape_html:true";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'coe' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', 'str' => <<'STR');
%p= "#{str}"
%p= escape_once("#{str}")
%p&= "#{str}"
HAML
<script>alert("I'm evil!"); & &amp; not</script>
STR
is($htmloutput, <<HTML, $tname);
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
HTML
#WSE extended function -- idempotent escaping for proper HtmlOutput, &apos;
#From the Haml Reference
#
#Legacy Haml -- escape_html=>true
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>
#<p>&amp;lt;script&amp;gt;alert(&amp;quot;I'm evil!&amp;quot;); &amp;amp; &amp;amp; not&amp;lt;/script&amp;gt;</p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -12- escape_html &= escape_once - WSE extended functions - escape_html:false";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'coe' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', 'str' => <<'STR');
%p= "#{str}"
%p= escape_once("#{str}")
%p&= "#{str}"
HAML
<script>alert("I'm evil!"); & &amp; not</script>
STR
is($htmloutput, <<'HTML', $tname);
<p><script>alert("I'm evil!"); & &amp; not</script></p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
HTML
#WSE extended function -- idempotent escaping for proper HtmlOutput, &apos;
#From the Haml Reference
#
#Legacy Haml -- escape_html=>false
#<p><script>alert(\"I'm evil!\"); & &amp; not</script></p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "01Helpers -13- filter:escapehtml - WSE Haml alias for filter:escaped";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'coe' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.foogle
  :escaped
    <script>alert("I'm evil!"); & &amp; not</script>
.boogle
  :escapehtml
    <script>alert("I'm evil!"); & &amp; not</script>
HAML
is($htmloutput, <<'HTML', $tname);
<div class='foogle'>
  &lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;
</div>
<div class='boogle'>
  &lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;
</div>
HTML
#WSE enhanced filter:escaped and the WSE alias
#legacy haml:
# &lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;
}#>>>>>TODO

