#!/usr/bin/env perl
#
#09multiline.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/09multiline.t
#          ./perl $ make multiline
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

use Test::More tests=>18;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -01- Basic sungle multiline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p para1
%div
    First line |
    Second line |
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<div>
  First line Second line
</div>
<p>para2</p>
HTML
#BUG: Trailing whitespace added at end of laminated text "Second line "
#legacy:
#<p>para1</p>
#<div>\n  First line Second line \n</div>\n<p>para2</p>\n"
}#>>>>>TODO


#================================================================
$tname = "09Multiline -02- Basic single multiline - improper ML lexeme copied thru";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p   para1
%div
    First line|
    Second line|
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<div>
  First line|
  Second line|
</div>
<p>para2</p>
HTML
#got: "<p>para1</p>\n<div>\n  First line|\n  Second line|\n</div>\n<p>para2</p>\n"
#The REFERENCE says that whitespace separator is nec.: the infix lexeme is ' |'.
#That's what the lexer would remove before filling the AST.
#But how, then, will trailing space be interpreted? In the same
#way as leading space ... where the leading space is shortened
#for the necessary IndentSteps? Or ...? Let's check that out ...



TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -03- ";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%p para1
%div
    %p   First line   |
    #{var1}  |
      Third line   |
Fourth line   |
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<div>
  <p>First line variable1 Third line Fourth line</p>
</div>
<p>para2</p>
HTML
#legacy:
#<p>para1</p>
#<div>
#  <p>First line   variable1  Third line   Fourth line</p>
#</div>
#<p>para2</p>\n"
#Notice: In Legacy Haml multiline trailing whitespace is preserved
# Approximately, that is. Notice drop at last line, and see other tests in
# this suite, but initial whitespace is removed.
# (Perl text::haml varies from this.)
#
#This seems buggy, or at least inconsistent. But what treatment? Would seem,
#either, CONSOLIDATE all/both to single spaces (seems most appropriate, and
#this is indeed what WSE Haml specifies) or normalize them back to the
#"effective" BOD (the left-most margin in the text, since Multiline
#enforces NEITHER Offside/BOD, or OIR).
#
#Legacy Bug: Compare drop of trailing space after "Fourth line" with add of
#trailing space in the bug above.
#
#Related: Note, also, the trailing whitespace that _is_ preserved is
#NOT ADJUSTED for the wspc nec. for the syntax.
#That is, the 'lexer' should have removed the lexeme " |" from each of these
#lines, the AST would reflect that the (now-sans-' |') content block is a
#multiline content block, and then the multiline code processor should
#process/handle/preserve the content, including the _remaining_ spaces.
#Rather than considering the minimum 'separating' whitespace
#as being contributed from the "    |" we should consider that for Multiline
#the "\n...IndentSteps..." is being CONSOLIDATED to " ".
#
#Notice: Initial whitespace (on first the line, after tag) is removed,
# unless supplied via interpolation ... the usual treatment in WSE Haml.
}#>>>>>TODO


#================================================================
$tname = "09Multiline -04- Single multiline - As-if Interpolated + HamlComment - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "VarStrPt1\nVarStrPt2" );
%div
  %p
    First line |
    VarStrPt1  |
    -# Breaking Haml Comment
    VarStrPt2   |
    Third line  |
    Fourth line |
    Foobar
HAML
is($htmloutput, <<HTML, $tname);
<div>
  <p>
    First line VarStrPt1
    VarStrPt2   Third line  Fourth line
    Foobar
  </p>
</div>
HTML
#Legacy Haml
#Compare this with the next several RSpec cases
#
#In this case, the HamlSource is manipulated to yield the same HtmlOutput
#as the actual interpolation case, which interpolates the newline
#See below for more comments.


#================================================================
$tname = "09Multiline -05- Single multiline - As-if Interpolated + Simple ML break - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "VarStrPt1\nVarStrPt2" );
%div
  %p
    First line |
    VarStrPt1
    VarStrPt2   |
    Third line  |
    Fourth line |
    Foobar
HAML
is($htmloutput, <<HTML, $tname);
<div>
  <p>
    First line
    VarStrPt1
    VarStrPt2   Third line  Fourth line
    Foobar
  </p>
</div>
HTML
#Legacy Haml
#Compare this with the above RSpec case, and several below.
#
#This case shows what would happen should an embedded newline be
#taken as 'literal' substitution _before_ Multiline syntax is
#processed. That would be an inversion of a more conventional
#parsing, wherein a dynamic variable substitution would happen
#only _after_ the syntax tree has been generated.
#See below for more comments.


#================================================================
$tname = "09Multiline -06- Single multiline - Interpolated Newline - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "VarStrPt1\nVarStrPt2" );
%div
  %p
    First line |
    #{varstr}  |
    Third line  |
    Fourth line |
    Foobar
HAML
is($htmloutput, <<HTML, $tname);
<div>
  <p>
    First line VarStrPt1
    VarStrPt2  Third line  Fourth line
    Foobar
  </p>
</div>
HTML
#Legacy Haml
#Compare this with the prior, and the following RSpec cases
#
#This case reveals an odd reversal in the legacy implementation:
#surface syntax is interpreted _after_ content semantics.
#In this case, the HamlSource has an interpolation form, which
#is given a phrase containing a newline.
#Notice that although the interpolation form falls within a
#Multiline Element's ContentBlock, the result is as if the
#newline broke the Multiline, and started a new Multiline for
#the next few lines. But the prior RSpec case shows that given those
#inputs a different result obtains. Instead it renders as if a
#Haml Comment were inserted (or, in WSE Haml, as if a Whiteline
#had been inserted). But that's an odd result too.
#
#The next RSpec case shows what we expect in WSE Haml, and discusses
#the parsing model


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -07- Single multiline - Interpolated newline - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "VarStrPt1\nVarStrPt2" );
%div
  %p
    First line |
    #{varstr}  |
    Third line  |
    Fourth line |
    Foobar
HAML
is($htmloutput, <<HTML, $tname);
<div>
  <p>
    First line VarStrPt1 VarStrPt2 Third line Fourth line
    Foobar
  </p>
</div>
HTML
#Legacy Bug + WSE Extensions
#WSE Haml result when Multiline ContentBlock contains interpolated newline
#(Note: Also WSE Haml results for consolidating whitespace, etc)
#
#Compare with cases above. What is happening in WSE Haml:
#The lexer builds an AST having the %p as a node, having a Nested 
#ContentBlock, and having as children two syntactic forms: 
#the first child is a Multiline node, the second child is a Plaintext node.
#As we already know, the lexer strips the ContentBlock of Multiline 
#Elements of the Multiline Lexemes -- leaving just the lines to be 
#processed (including interpolation ... which makes it obvious that an
#interpolated ' |\n.. |\n' cannot trigger a Multiline), and then finally
#combined according to Multiline _semantics_.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -08- Single multiline - interpolated newline with Pipe";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "VarStrPt1 |\nVarStrPt2 " );
%div
  %p
    First line |
    #{varstr}  |
    Third line  |
HAML
is($htmloutput, <<WSE, $tname);
<div>
  <p>
    First line VarStrPt1 | VarStrPt2 Third line
  </p>
</div>
WSE
isnt($htmloutput, <<LEGACY, $tname);
<div>
  <p>
    First line VarStrPt1 |
    VarStrPt2   Third line
  </p>
</div>
LEGACY
#Confirming: Legacy Haml properly does NOT interpret interpolated
# Multiline lexeme.
}#>>>>>TODO


#================================================================
$tname = "09Multiline -09- Haml Comment in middle of Multiline - Deprecated";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
First line |
Second line |
-#Third line
Another online Hamlmultiline |
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
First line Second line
Another online Hamlmultiline
Next Content Block
HTML
#First, see WSE Implementation Notes, and notes in this spec re processing
# sequence and abstract grammar.
#Then: All of that points to a Haml Comment being UNABLE to break a
# Multiline, or any other multi-line structure.
#However: there's a legacy Haml problem here ... a workaround for
# reasonably expected behavior (that a Whiteline  _would_ separate
# two adjacent Multilines) was to use a Haml Comment. 
#So, although that is clearly I<whack>, we'll have to support it too.
#
#Deprecated: Using a Haml Comment to demarcate two adjacent Multiline Elements
#is now deprecated. The recommended idiom is now the Whiteline. 
#BUG: Excessive trailing whitespace at end of laminated lines


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -10- Haml Comment inside Multiline block, w/Multiline syntax, Deprecated";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML' );
First line |
Second line |
-# Third line |
Last line |
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
First line Second line\nLast line \nNext Content Block
HTML
#Legacy:
#First line Second line -#Third line Last line \nNext Content Block
#
#Haml comment (which is "Haml-inactive") should be removed by parser
#before Haml-active HamlSource is considered. The result should be
#a single multiline before the final text line.
#Although that's clearly still an Haml comment we've got an unexpected
#re-ordering of parsing rules -- Haml comment is carried through to Html
#Interesting that although HamlComment is essentially transparent
#to content, it serves to demarcate the two multiline Elements
#So, the above is a BUG
#HOWEVER, WSE provides backward compatibility for this aberration,
# So, in the Multiline here, that is a Haml Comment.
#Deprecated: Using a Haml Comment to demarcate two adjacent Multiline Elements
#is now deprecated. The recommended idiom is now the Whiteline.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -11- Multiline either side of Whiteline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
First line |
Second line |

Another online Hamlmultiline |
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
First line Second line
Another online Hamlmultiline
Next Content Block
HTML
#BUG: Despite being waived off in Haml Issues: WSE calls this a BUG
#How can Whiteline be of less semantic potency than a Haml comment line?
# A Whiteline must be more potent, therefore the absence of the " |" must
# be semantically significant.
# - HamlComment is an active Haml lexeme, but in the (abbrev version of the)
#   Haml 'hierarchy' of: pi, meta, macros + expr + transforms, content
#   The first two are different from the latter two in that those
#   (most simply) are not carried through to output (there are oth diff)
# - Interesting that although HamlComment is essentially transparent
#   to content, it serves to demarcate the two multiline Elements
# - Where does Whiteline fit in the above hierarchy?
#   Is it a fifth level/category? Does it fall btw meta and macros et al?
#   Or btwn macros et al and content?
# - Under WSE, we consider Whiteline in the latter: either in content,
#   or between that and macros.
# - Under that model, a Whiteline must certainly delimit the two blocks
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -12- Whiteline w/Multiline syntax inside Multiline block, improper ML lexeme";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
First line |
Second line |
|
Last line |
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
First line Second line Last line \nNext Content Block
HTML
#legacy: "First line Second line \n|\nLast line \nNext Content Block\n"
#Bug: That unexpected extra trailing space, after "Second line"
#Bug: The multiline block breaks at the 'Whiteline' having just '|'
#     but ... is it simply because the bare '|' is not the proper ' |'?
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -13- Whiteline w/Multiline syntax inside Multiline block - w/proper ML lexeme";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
First line |
Second line |
 |
Last line |
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
First line Second line Last line \nNext Content Block
HTML
#Bug: An apparent bug, if you're a user expecting it to work like
#     a full multiline. Correcting to a proper " |" doesn't fix things.
#     Now it provokes an illegal indentation error (b/c hidden from you
#     until you remove the spaces, there's two newlines being inserted.)
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -14- Multiline supports Mixed Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%p Baz |
 More     |
  Text    |
HAML
is($htmloutput, <<HTML, $tname);
<p>Baz More Text</p>
HTML
#Simple case: Notice that Multiline supports Mixed Content
#(But not if the Inline Content is an expression. Error:  %p= "Baz" | )
#WSE: Multiline CONSOLIDATES whitespace
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "09Multiline -15- Multiline, last line w/o operator";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%whoo
  %hoo
    I think this might get    |
    pretty long so I should   |
    probably make it          |
    multiline so it does not  |
    look awful.
  %p This is short.
HAML
is($htmloutput, <<HTML, $tname);
<whoo>
  <hoo>
    I think this might get pretty long so I should probably make it multiline so it does not
    look awful.
  </hoo>
  <p>This is short.</p>
</whoo>
HTML
#Variant from perl t/multiline.t; legacy text::perl sucks up the "look awful"
#Legacy Haml:
#<whoo>
#  <hoo>
#    I think this might get    pretty long so I should   probably make it          multiline so it does not
#    look awful.
#  </hoo>
#  <p>This is short.</p>
#</whoo>
#Notice: That is, in Legacy Haml "\nlook awful" ... is _properly_ not included
#in the multiline
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -16- Multiline, last line w/o operator - Perl test::more example";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%whoo
  %hoo I think this might get |
    pretty long so I should   |
    probably make it          |
    multiline so it does not  |
    look awful.
  %p This is short.
HAML
is($htmloutput, <<HTML, $tname);
<whoo>
  <hoo>I think this might get pretty long so I should probably make it multiline so it does not
    look awful.
  </hoo>
  <p>This is short.</p>
</whoo>
HTML
#Requires WSE to accept Mixed Content ContentModel
#  -- the "\nlook awful" triggers Mixed Content for the %hoo Element
#Variant of perl t/multiline.t for legacy text::haml
# Compared to text::haml error for Nested Content (previous test),
# this works in legacy text::haml
}#>>>>>TODO

