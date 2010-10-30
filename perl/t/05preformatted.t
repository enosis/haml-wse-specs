#!/usr/bin/env perl
#
#05preformatted.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/05preformatted.t
#          ./perl $ make preformatted
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

use Test::More tests=>17;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#The first 12 cases are a study of the results for the table given
#in file Haml_WhitespaceSemanticsExtension_ImplementationNotes,
#called: Preformatted-type Language Constructs and HtmlOutput.
#The cases are numbered 1..12 across the three rows (atag, ptag, vtag) and
#down four columns (direct, filter:preserve, filter:preformatted, and HereDoc).
#
#Those cases, in summary:
#01: atag,direct   :: same indentation as 02 and newline rendering (different tag)
#02: ptag,direct   :: same indentation as 01 and newline rendering (different tag)
#03: vtag,direct   :: unique
#04: atag,f:presrv :: different indentation but similar to 06,08
#05: ptag,f:presrv :: unique
#06: vtag,f:presrv :: same as 8:ptag,f:prefmt; close to 04
#07: atag,f:prefmt :: unique
#08: ptag,f:prefmt :: same as 6:vtag,f:presrv; close to 04
#09: vtag,f:prefmt :: unique
#10: atag,Heredoc  :: unique
#11: ptag,Heredoc  :: unique
#12: vtag,Heredoc  :: unique .. verbatim contentblock


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";


#================================================================
$tname = "05Preformatted -01- Tag Category and HtmlOutput Grid: atag, direct";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %atag
     Nested lines
       More Nested lines
      Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <atag>
      Nested lines
      More Nested lines
      Final line
   </atag>
</div>
HTML
#OutputIndentStep = three spaces
#On output, ContentBlock is indented three spaces from Head (atag)
#w/oir=>loose, if CB lines were tags, additional nesting applies
#but with plaintext, it is all just aligned on the OutputIndentStep
#B/c oir=>loose in atag, with plaintext, no leading whitespace.
#
#Same indentation and newline treatment case 02: "ptag, direct",
#  with different tag.


#================================================================
$tname = "05Preformatted -02- Tag Category and HtmlOutput Grid: ptag, direct";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %ptag
     Nested lines
       More Nested lines
      Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <ptag>
      Nested lines
      More Nested lines
      Final line
   </atag>
</div>
HTML
#In WSE Haml, an option:preserve tag accepts Nested
# (but not Mixed, as Inline fragement would be confused for legacy-style ptag CB).
#The nested content follows "atag-direct" semantics (above)
#
#Same indentation and newline treatment case 01: "atag, direct",
#  with different tag.


#================================================================
$tname = "05Preformatted -03- Tag Category and HtmlOutput Grid: vtag, direct";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %vtag
     Nested lines
       More Nested lines
      Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <vtag>
Nested lines
  More Nested lines
 Final line
   </vtag>
</div>
HTML
#A 'vtag' shifts a direct content block to indentation 0
#This is a one of the unique results of these combinations.
#
#Unique rentering among these cases


#================================================================
$tname = "05Preformatted -04- Tag Category and HtmlOutput Grid: atag, filter:preserve";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %atag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <atag>
       Nested lines&#x000A;   More Nested lines&#x000A;  Final line
   </atag>
</div>
HTML
# BOD for :preserve is offset from :preserve by the amount
# that the :preserve Head is offset from its parent's Head.
# In this case, 2 spaces, leaving a 1-space Leading Whitespace
# :preserve will protect/preserve that leading whitespace.
# atag will place the content block at plus one OutputIndentStep
# Of course, none of this will alter the UA rendering, it
# concerns only the format of HtmlOutput.
#
# Rendered very similarly (transform \n) to the following cases:
#    case 06 "vtag, preserve"
#    case 08 "ptag, preformatted
# which instead push the leading whitespace to column 0.


#================================================================
$tname = "05Preformatted -05- Tag Category and HtmlOutput Grid: ptag, filter:preserve";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %ptag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <ptag> Nested lines&#x000A;   More Nested lines&#x000A;  Final line</ptag>
</div>
HTML
# A unique rendering among these cases


#================================================================
$tname = "05Preformatted -06- Tag Category and HtmlOutput Grid: vtag, filter:preserve";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %vtag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <ptag> Nested lines&#x000A;   More Nested lines&#x000A;  Final line</ptag>
</div>
HTML
# Same rendering as: case 08 "ptag, preformatted"
# Rendered very similarly to case 4 "atag, preserve",
# except this case pushes the leading whitespace to column 0.


#================================================================
$tname = "05Preformatted -07- Tag Category and HtmlOutput Grid: atag, filter:preformatted";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %atag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <atag>
      Nested lines
        More Nested lines
       Final line
   </atag>
</div>
HTML
#Notice the first Textline of the ContentBlock -- it starts
#at column seven, just as the prior atag case: two OutputIndentSteps,
#plus the one-space Leading Whitespace.
#
#Unique result
# :preformatted delivers a CB with protection of a 1-space leading whitespace
# and 'atag' positions the CB at the OutputIndentStep from <atag>


#================================================================
$tname = "05Preformatted -08- Tag Category and HtmlOutput Grid: ptag, filter:preformatted";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %ptag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <ptag>
 Nested lines&#x000A;   More Nested lines&#x000A;  Final line
   </ptag>
</div>
HTML
#We get the :preformatted effects, then the ptag preserve effects
#
#Same rendering as: case 06 "vtag, preserve"
#Rendered very similarly to case 4 "atag, preserve", except this case
#pushes the leading whitespace to column 0.


#================================================================
$tname = "05Preformatted -09- Tag Category and HtmlOutput Grid: vtag, filter:preformatted";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %vtag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <vtag>
 Nested lines
   More Nested lines
  Final line
   </vtag>
</div>
HTML
#We get the :preformatted effects (which preserves that leading Whitespace)
#then the vtag preformatted effects (which shifts to 0, but the Leading
#whitespace is preserved)
#
#Unique rendering among these cases


#================================================================
$tname = "05Preformatted -10- Tag Category and HtmlOutput Grid: atag, HereDoc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %atag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <atag>
       Nested lines
         More Nested lines
        Final line
   </atag>
</div>
HTML
#Same as atag w/filter:preformatted
# - atag shifts CB to align on OutputIndentStep
# - CB has one column of Leading Whitespace
#
#Unique


#================================================================
$tname = "05Preformatted -11- Tag Category and HtmlOutput Grid: ptag, HereDoc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %ptag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <ptag>
     Nested lines&#x000A;       More Nested lines&#x000A;      Final line
   </ptag>
</div>
HTML
#Unique case


#================================================================
$tname = "05Preformatted -12- Tag Category and HtmlOutput Grid: vtag, HereDoc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %vtag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <vtag>
     Nested lines
       More Nested lines
      Final line
   </vtag>
</div>
HTML
#unique rendering -- verbatim contentblock


#================================================================
$tname = "05Preformatted -13- %pre +observe BlockOnsideDemarcation, with nested content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code', 'ptag' ],
                         preformatted => [ 'ver', 'pre', 'code', 'vtag' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%div
  %pre
    o           .'`/
        '      /  (
      O    .-'` ` `'-._      .')
         _/ (o)        '.  .' /
         )       )))     ><  <
         `\  |_\      _.'  '. \
           `-._  _ .-'       `.)
       jgs     `\__\
  %p
  <a href='http://dev.w3.org/html5/spec/content-models.html'>HTML5 Content Models</a>,
  from
  <a href='http://webspace.webring.com/people/cu/um_3734/aquatic.htm'>Joan G. Stark</a>
HAML
is($htmloutput, <<HTML, $tname);
<div>
   <pre>
o           .'`/
    '      /  (
  O    .-'` ` `'-._      .')
     _/ (o)        '.  .' /
     )       )))     ><  <
     `\  |_\      _.'  '. \
       `-._  _ .-'       `.)
   jgs     `\__\
   </pre>
   <p>
     <a href="http://dev.w3.org/html5/spec/content-models.html">HTML5 Content Models</a>,
     from
     <a href="http://webspace.webring.com/people/cu/um_3734/aquatic.htm">Joan G. Stark</a>
   </p>
</div>
HTML
#Notice: %pre is not a member of opt:preserve, but opt:preformatted
#Legacy Haml:Illegal nesting
#WSE Haml:
#  %pre in opt:preserve accepts nested input, but as if 'atag': preserve mechanics not performed
#  WSE Haml as opt:prefmtd acts as if %pre accepted nested input _and_ preserved structure
#  Except newlines not transformed, and
#   the output indentation is SIMILAR to, but DIFFERENT from opt:preserve
#    - opt:preserve 'ptag': determines the IndentStep for the tag's ContentBlock,
#          this equals a single OutputIndentStep added to the the 'ptag'
#          indentation
#    - opt:preformatted uses 'shift of the rigid block' to indentation 0
#          So, at least one line has no leading wspc
#  Compared:
#    with %vtag: ContentBlock to %vtag is shifted as a RIGID BLOCK up to 0 Indentation
#    with filter:preformatted: uses :preserve-semantics for offset (Parent-to-:presv)
#    with HereDoc uses absolute indentation


#================================================================
$tname = "05Preformatted -14- %pre +NOTobserve BlockOnsideDemarcation: requires HereDoc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%argh
  %pre<<POEM
         Higher still and higher
           From the earth thou springest
         Like a cloud of fire;
           The blue deep thou wingest,
  And singing still dost soar, and soaring ever singest.
POEM
  %p
    <a href='http://www.w3.org/TR/html401/struct/text.html'>HTML4.01 Paragraphs, Lines, and Phrases</a>
    citing Shelly,
    %succeed '.'
      %em To a Skylark
HAML
is($htmloutput, <<HTML, $tname);
<argh>
  <pre>
         Higher still and higher
           From the earth thou springest
         Like a cloud of fire;
           The blue deep thou wingest,
  And singing still dost soar, and soaring ever singest.
  </pre>
  <p>
    <a href="http://www.w3.org/TR/html401/struct/text.html">HTML4.01 Paragraphs, Lines, and Phrases</a>
    citing Shelly, <em>To a Skylark</em>.
  </p>.
</argh>
HTML
#Note: %pre is in option:preformatted
#WSE Haml: HereDoc provides ContentBlock to option:preformatted tag (vtag)
#  HereDoc assy the CB with leading indents preserved
#  The vtag shifts the CB to Indentation 0
#  (which results in preserved leading whitespace, the indentation replayed)


#================================================================
$tname = "05Preformatted -15- %pre +NOTobserve BlockOnsideDemarcation: requires HereDoc, using <<-";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%tex
  %pre<<-DEK
  Roses are red,
    Violets are blue;
  Rhymes can be typeset
    With boxes and glue.
                      DEK
  = succeed(".")
    %p Donald E. Knuth, 1984,
      %em The TEXbook
HAML
is($htmloutput, <<HTML, $tname);
<tex>
  <pre>
  Roses are red,
    Violets are blue;
  Rhymes can be typeset
    With boxes and glue.
  </pre>
  <p>Donald E. Knuth, 1984, <em>The TEXbook</em></pm></p>.
</tex>
HTML


#================================================================
$tname = "05Preformatted -16- %code Legacy Illeg. Nesting. option:preformatted over preserve - WSE Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'textarea', 'code' ],
                         preformatted => [ 'ver', 'pre', 'code' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
- html_tabstring('   ')
%zap
  %code
    def fact(n)  
      (1..n).reduce(1, :*)  
    end  
%spin
  %code accept:
         do
         :: np_
         od
HAML
is($htmloutput, <<HTML, $tname);
<zap>
   <code>
def fact(n)  
  (1..n).reduce(1, :*)  
end  
   </code>
</zap>
<spin>
  <code>accept:
do
:: np_
od
  </code>
</spin>
HTML


}#>>>>>TODO
