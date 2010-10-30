#!/usr/bin/env perl
#
#07mixedcontent.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/07hamlcomments.t
#          ./perl $ make hamlcomments
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



#================================================================
$tname = "07HamlComments -01- Ordinary Inline Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %p para1
  -# Inline comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>para1</p>
  <p>para2</p>
</foo>
HTML


#================================================================
$tname = "07HamlComments -02- Ordinary Mixed Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%bar
  %p para1
  -# Inline comment
    Nested cont
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bar>
  <p>para1</p>
  <p>para2</p>
</bar>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -03- Ordinary Mixed Content - Orderly Indentation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %p para1
  -# Inline comment
    Nested cont
      Indented
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <p>para1</p>
  <p>para2</p>
</baz>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -04- Ordinary Mixed Content - Not Orderly Indentation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%fum
  %p para1
  -# Inline comment
        Nested cont
      Indented
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<fum>
  <p>para1</p>
  <p>para2</p>
</fum>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -05- Ordinary Mixed Content - SubElement";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%qux
  %p para1
  #id1
     -# Inline comment
        Nested comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<qux>
  <p>para1</p>
  <div id='id1'></div>
  <p>para2</p>
</qux>
HTML
#Legacy permits sub-Element Haml comments
#But legacy Haml (improperly) processes Haml Comment CommentBlock
#  as if HamlComments are member of set of producing tags
#  That is: as a ISWIM lang, only the fact that there is 
#   _indentation_ should matter to HamlComments (which cannot contain
#   sub-Elements) not the amount of indentation.
#BUG: Also, legacy Haml notices too late that the div#id1 contentblock
#  is empty, and thus should be rendered <starttag><endtag> rather
#  than stacked, as if containing nested content.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -06- Ordinary Mixed Content, SubElement - Not Orderly Indentation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bongo
  %p para1
  #id1
     -# Inline comment
           Nested cont
      Indented
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bongo>
  <p>para1</p>
  <div id='id1'></div>
  <p>para2</p>
</bongo>
HTML
#WSE: WSExtensions permit any indentation, provided abides BOD/Offside Rule
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -07- Haml Comment inside Multiline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%zork
  First line |
  Second line |
  -#Third line |
  Last line |
  Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
<zork>
  First line Second line
  Last line
  Next Content Block
</zork>
HTML
#Haml comment (which is "Haml-inactive") should be removed before
#Haml-active HamlSource is processed. An author would expect any
#content on a Haml Comment line to be inert.
#However, for backward compatibility, the Haml Comment will
#interrupt a Multiline
# ... and for sensible least-surprise, EVEN within a Multiline lexeme.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -08- Between Multiline, Backward Compatibility";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%gork
  First line  |
  Second line |
  -#Third line
  Last line   |
  Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
<gork>
  First line Second line
  Last line
  Next Content Block
</gork>
HTML
#Backward compatibility -- WSE works like legacy
#but prefer correcting this: HamlComment should be invisible
#BUG Legacy Haml: in WSE, removing the extra trailing whitespaces
}#>>>>>TODO


#================================================================
$tname = "07HamlComments -09- In Html Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bork
  %p Para
  /
    First line
    Second line
    -#Third line
    Last line
  Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
<bork>
  <p>Para</p>
  <!--
    First line
    Second line
    Last line
  -->
  Next Content Block
</bork>
HTML
# Works b/c this Html Comment ContentBlock observes OIR:legacy


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -10- Comment (Inline) within nested Html Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "  Inline  " );
%p Para
/
  First line
  Second line
  -#Third line
    Last line
Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
<p>Para</p>
<!--
  First line
  Second line
  Last line
-->
Next Content Block
HTML
#WSE extension/interpretation:
#This is a case of resolving ambiguity by reference to priority
#Html Comments are semantic; Haml Comments are not.
#The Html Comment Nested Content Block extends (by Offsides) through
#to the end of "Last line". Here the Haml Comment Inline Content
#can be, and should be, interpreted in its minimum extent.
#Therefore the extent of the contained-Haml Comment is the one line.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -11- Comment (Nested) within Nested Html Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%spam
  %p Para
  /
    First line
    Second line
   -#
    Third line
      Last line
  Next Content Block
HAML
is($htmloutput, <<HTML, $tname);
<spam>
  <p>Para</p>
  <!--
    First line
    Second line
  -->
  Next Content Block
</spam>
HTML
#By comparison to the above, this RSpec shows how the minimum extent of
#  the Haml Comment must be interpreted under Nesting Content rules
#  ... so a new BOD is established and prevails until Offsides or Whiteline
#  (see below)
#Authors have two ways of commenting-out in such contexts, including
#  'ordinary' Haml tags (%p, etc).
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -12- Ordinary Mixed Content, Haml Comment nested called Mixed";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%eggs
  %p para1
  %p para2

    -# Inline comment
HAML
is($htmloutput, <<HTML, $tname);
<eggs>
  <p>para1</p>
  <p>para2</p>
</eggs>
HTML
#Bug: Haml comments should be removed before considering content
#Adding that interceding Whiteline doesn't defang syntax error
# (just as would be the case in the Haml comment were, instead, plain text)
#This produces results different than expected under text::haml t/comments.t
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "07HamlComments -13- Ordinary Mixed Content, SubElement - Sibling";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bac
  %p para1
  #id1
     -#Inline comment
        Nested cont


        %sub/
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bac>
  <p>para1</p>
  <div id='id1'>

    <sub />
  </div>
  <p>para2</p>
</bac>
HTML
#WSE: Whiteline should break Haml Comments
#Accounting for WSE Whiteline consolidating multiple whiteline,
#there's ends up on HtmlOutput one whiteline then the empty <sub />
}#>>>>>TODO

