#!/usr/bin/env perl
#
#04preserve.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/04preserve.t
#          ./perl make preserve
#
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default
#Notice: Trailing whitespace is present on some Textlines

#Preserve: observes Offside, requires OIR,
#Replays all whitespace: initial, leading, interior, trailing

use strict;
use warnings;

use Test::More tests=>17;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#================================================================
$tname = "04Preserve -01- %p Inline Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p Inline Paragraph Text
HAML
is($htmloutput, <<HTML, $tname);
<p>Inline Paragraph Text</p>
HTML
#For reference


#================================================================
$tname = "04Preserve -02- %p Nested Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
  Nested Paragraph Text
HAML
is($htmloutput, <<HTML, $tname);
<p>\n  Nested Paragraph Text\n</p>
HTML
#For reference


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -03- %p Constant Nesting in plaintext content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
  Nested Para Text1
  Nested Para Text2
  Nested Para Text3
HAML
is($htmloutput, <<HTML, $tname);
<p>\n  Nested Para Text1\n  Nested Para Text2\n  Nested Para Text3\n</p>
HTML
#The trailing spaces on the plaintext lines are removed.
}#>>>>>TODO


#================================================================
$tname = "04Preserve -04- %atag plus :preerve - leading whitespace preserved";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
    :preserve
       funct()
           expression
          end
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <bar>
     funct()   &#x000A;     expression &#x000A;    end
  </bar>
</foo>
HTML
#Notice: funct() is indented +1 than OutputIndentStep,
# and all other lines are indented from that same BOD.


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -05- %code Inline Content (dynamic) - initial and interior whitespace preserved";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%code= " inline expr code()  \n     %nested code:"
HAML
is($htmloutput, <<HTML, $tname);
<code> inline expr code()  &#x000A;     %nested code:</code>
HTML
#bug-let nit: preserve leading whitespace from expr or interpolation
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -06- %cope (non-preserve) Inline Content (dynamic) - leading whitespace - =expr";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%laugh
  %cry
    %cope= " inline expr code()  \n     nested code:"
HAML
is($htmloutput, <<HTML, $tname);
<laugh>
  <cry>
    <cope> inline expr code()
           nested code:
    </cope>
  </cry>
</laugh>
HTML
#Legacy:
#laugh>
# <cry>
#   <cope>
#      inline expr code()  \n         nested code:
#   </cope>
# </cry>
#/laugh>
#
#Notice: 'cope' is not 'code': it is NOT in option:preserve
#WSE Haml ... honoring author inline by running results tight after
#the tagstart.
#Copy through that initial space from expr/interp even for non-preserve
# or non-preformatted tag
#For regular tags (non-preserve/non-preformatted), both legacy and
# WSE Haml normalize the OutputIndent in the results for cases where
# newlines are 'interior' to the expr/interp.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -07- %code (preserve) Inline Content (dynamic) - leading whitespace - ~expr";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%code~ " inline expr code()  \n     nested code:\n"
HAML
is($htmloutput, <<HTML, $tname);
<code> inline expr code()  &#x000A;     nested code:&#x000A;</code>
HTML
#Contains WSE extensions too
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -08- =find_and_preserve - <pre>, no tag, and <xre> (non-option-preserve)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz\n</pre>")
  = find_and_preserve("Foo\n%Bar\nBaz")
  = find_and_preserve("Foo\n<xre>Bar\nBaz\n</xre>")
HAML
is($htmloutput, <<HTML, $tname);
<zot>
  Foo\n  <pre>Bar&#x000A;Baz</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz\n  </xre>
</zot>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -09- ~expr - <pre>, no tag, and <xre> (non-option-preserve)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%zot
  ~ "Foo\n<pre>Bar\nBaz\n</pre>"
  ~ "Foo\n%Bar\nBaz"
  ~ "Foo\n<xre>Bar\nBaz\n</xre>"
HAML
is($htmloutput, <<HTML, $tname);
<zot>
  Foo\n  <pre>Bar&#x000A;Baz\n</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz\n</xre>
</zot>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -10- %code Inline Content - Leading and trailing whitespace";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %code= "book-content =\n     attribute id { text },\n     attribute available { text },  "
  %code= "     isbn-element,\n     title-element,\n     author-element*,\n     character-element*  "
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <code>book-content =&#x000A;     attribute id { text },&#x000A;     attribute available { text },</code>
  <code>     isbn-element,&#x000A;     title-element,&#x000A;     author-element*,&#x000A;     character-element*</code>
</foo>
HTML
#got:
#
#The preserve option doesn't satisfy two other requirements for
#treatment under rules similar to CSS white-space:pre.
#Initial, Leading, and trailing whitespace should be preserved.
#Thinking regarding Initial whitespace: An author should be able
#to control the OutputIndent even across multiple %code elements
#... which means that a following %code section should be able to
#begin with the same OutputIndent as that of the last line of the
#prior %code section, for example, and continue to add even more
#such %code sections as the code definition develops.
#A picture of a typical UA (CSS-neutral) rendering for the
#Relax NG schema in the %code above:
#
#book-content =
#   attribute id { text },
#   attribute available { text },
#   isbn-element,
#   title-element,
#   author-element*,
#   character-element*
#
#As to trailing whitespace, preservation is appropriate. For one,
#it will match the treatment in multiline text of the internal
#line-ending whitespace. Moreover, even in single-line cases,
#rendering of the lines may (according to UA or CSS differences)
#vary depending on the presence of the whitespace. (Such as with
#centering.)
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -11- %code - impermissible Nested Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%eggs
  %code
    proc()  
    moreproc()  
%spam
  %cope
    funct()
    morefunct()
%saus
  %code and bacon
    %car/
    %cdr/
HAML
is($htmloutput, <<HTML, $tname);
<eggs>
  <code>
    proc()  
    moreproc()  
  </code>
</eggs>
<spam>
  <cope>
    funct()
    morefunct()
  </cope>
</spam>
<saus>
  <code>and bacon</code>
  <car />
  <cdr />
</saus>
HTML
#Legacy Bug
#Mixed or Nested content is INELIGIBLE for 'preserve' treatment under
# legacy Haml, and WSE Haml does not change this specified treatment.
#In the example, the nested content to %code is partially interpreted
# under preserve, including legacy indent bug.
#BUT, the reasonable expectation for legacy Haml (and WSE Haml) is as
# follows (using %code as an example)
#  - Case A: If the %code Head has (legal) Inline Content, it is the
#      content block for 'preserve-style' %code, and the %code Element
#      is complete; alternatively ...
#  - Case B: If the %code Head lacks Inline Content, then the
#      content block for the 'preserve-style' %code is EMPTY.
#  - Case C: Case B (empty Inline) PLUS apparently nesting lines:
#      The %code Head should now be considered a normal tag with
#      Nested Content, not a 'preserve-style' tag: same indents and
#      whitespace handling as %p or %anytag.
#  - Case D: Case A (Inline) PLUS apparently nesting lines:
#      This is prohibited in legacy Haml; permitted in WSE Haml
#      Because %code in is 'option:preserve' there's special handling.
#      As mentioned above, the Inline Content completed the %code Element.
#      So, these 'nesting' lines must be something else.
#      Under OIR:strict or loose, they are considered siblings to the
#      %code element.
#      Without the special handling for 'option:preserve', say for
#      a normal tag, or 'option:preformatted', the entire Inline plus
#      Nested comprise a Mixed Content ContentBlock to the tag.
}#>>>>>TODO


#================================================================
$tname = "04Preserve -12- %code - impermissible Nested Content, indented";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
throws_ok { $haml->render(<<'HAML')} 'Haml::SyntaxError','nesting in text illegal';
%zap
  %code
    def fact(n)
      (1..n).reduce(1, :*)
    end
HAML
#As in, you know, code.
#WSE Haml does not change this.


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -13- %code preserve Indented Nested Content, plus thru preserve filter";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%zap
  %code
    :preserve
        def fact(n)
          (1..n).reduce(1, :*)
        end
HAML
is($htmloutput, <<HTML, $tname);
<zap>
  <code>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end  </code>
</zap>
HTML
#Legacy:
#<zap>
#  <code>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end</code>
#</zap>
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "04Preserve -14- Indented Nested Content, thru preserve filter, no initial tag";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
:preserve
      def fact(n)
        (1..n).reduce(1, :*)
      end
%div
  %p para1
HAML
is($htmloutput, <<HTML, $tname);
def fact(n)  &#x000A;  (1..n).reduce(1, :*)  &#x000A;end
<div>
  <p>para1</p>
</div>
HTML
#Legacy Haml: Minor Bug/Artifact
#In 'ordinary' HamlSource, a :preserve Head won't be the first of the file
#AND, the :preserve Head will calc the Leading Whitespace by subtracting
#  the by-then global IndentStep (def 2 spaces).
#IOW, it's surprising to see the content block of :preserve exert any
#  change on the external global state, since it is otherwise local.
#Recco:Don't set the IndentStep at this point ... since it is also
#  unnecessary, as it is logical that such a :preserve content block
#  be set hard left.
}#>>>>>TODO


#================================================================
$tname = "04Preserve -15- filter :preserve w/internal Haml tag, literal";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', var1 => 'variable1' );
%zig
  :preserve
    %p
      #{var1}
      para
HAML
is($htmloutput, <<HTML, $tname);
<zig>
  %p&#x000A;  variable1&#x000A;  para
</zig>
HTML


#================================================================
$tname = "04Preserve -16- Preserve and non-preserve leading and trailing wspc, newlines";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', metavar => "  Foo  \n  Bar \n\n" );
%tutu
  %p para1
  %code= metavar
  %cope= metavar
HAML
is($htmloutput, <<HTML, $tname);
<tutu>
  <p>para1</p>
  <code>  Foo  &#x000A;  Bar  &#x000A;</code>
  <cope>
      Foo  
      Bar  
  </cope>
</tutu>
HTML
#legacy:
#<tutu>
#  <p>para1</p>
#  <code>Foo  &#x000A;  Bar</code>
#  <cope>\n      Foo  \n      Bar\n  </cope>
#</tutu>
#
#Why should a preserve tag drop the initial wspc,
#  while a normal tag would copy through (adjusted) the leading wspc?
#Why should preserve remove trailing wspc, like nonpreserve?
#What should be the treatment for that double trailing newline?
#  -- it's inside an expr, not 'just' in a literal Whiteline
#  -- consolidate into one, then transform in preserve
#Note that the OutputIndent for the second line in the non-preserve
#  case is the result of the html_indent, whatever its then-current
#  value, plus the content author's extra spacing in the interpolated var.

