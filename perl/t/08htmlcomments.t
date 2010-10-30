#!/usr/bin/env perl
#
#08htmlcomments.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/08htmlcomments.t
#          ./perl $ make htmlcomments
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



#================================================================
$tname = "08HtmlComments -01- Ordinary Inline";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %p para1
  /Inline comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>para1</p>
  <!-- Inline comment -->
  <p>para2</p>
</foo>
HTML
#Notice: Initial wspc removed


#================================================================
$tname = "08HtmlComments -02- Ordinary Nested";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%bar
  %p para1
  /
      Nested Html Comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
%bar
  <p>para1</p>
  <!--
    Nested Html Comment
  -->
  <p>para2</p>
HTML
#Notice: Initial wspc removed for nested too


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -03- Nested multiple lines - Consistent indent";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %p para1
  /
     Nested Html Comment

     Second Nesting Continued
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Nesting Continued
  -->
  <p>para2</p>
</baz>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -04- Nested multiple lines - Consistent indent, Multiple Whitelines";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%qux
  %p para1
  /
     Nested Html Comment


     Second Nesting Continued
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<qux>
  <p>para1</p>
  <!--
    Nested Html Comment

    Second Nesting Continued
  -->
  <p>para2</p>
</qux>
HTML
#WSE: By default, Several consecutive Whitelines in HamlSource
#     are consolidated to a single whiteline on HtmlOutput.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -05- Nesting - Active Haml Tags";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%zork
  %p para1
  /
     Nested Html Comment
     %p Contained Haml
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<zork>
  <p>para1</p>
  <!--
    Nested Html Comment
    <p>Contained Haml</p>
  -->
  <p>para2</p>
</zork>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -06- Nesting - Active Haml Tags - Haml Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%gork
  %p para1
  /
     Nested Html Comment
     -#%p Contained Haml
     Second Html Comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<gork>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Html Comment
  -->
  <p>para2</p>
</gork>
HTML
#Haml comment is recognized too
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -07- Nesting - Active Haml Tags - Haml Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bork
  %p para1
  /
     Nested Html Comment
     -#
       %p Contained Haml
     Second Html Comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bork>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Html Comment
  -->
  <p>para2</p>
</bork>
HTML
# Nested Haml Comment (in any haml tag having Nested/Mixed) will
# observe Offsides and Whiteline delimitation of its Content Block
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -08- Nested - Mistaken nested comments";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bongo
  %p para1
  /
     Nested Html Comment
     Second Nesting
     /  Mistaken nesting
     /
        Another mistake
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bongo>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Nesting
    / Mistaken nesting
    /
    Another mistake
  -->
  <p>para2</p>
</bongo>
HTML
#Legacy Haml:
#<p>para1</p>
#<!--\n  Nested Html Comment\n  Second Nesting
#  <!-- Mistaken nesting -->\n  <!--\n    Another mistake\n  -->\n-->
#<p>para2</p>\n"
#BUG: Any mistaken child Html comments should be recognized and handled
#     wrt the context -- they should not be rendered into an enclosed
#     Html comment -- the choices are: die, defang the Haml in some way,
#     or defang the Html.
#     Defanging the Haml:
#      - notice that inside an Html comment the / is just /
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -09- Nested muultiple lines - Mixed indent - OIR:strict";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bingo
  %p para1
  /
     Nested Html Comment
           Second Nesting
        Third Nesting
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<bingo>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Nesting
    Third Nesting
  -->
  <p>para2</p>
</bingo>
HTML
#WSE: default for Html Comments is OIR:loose, but this example
# is compliant with OIR:strict
}#>>>>>TODO



TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -10- Nested multiple lines - Mixed indent - OIR:loose (default)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML' );
%beppo
  %p para1
  /
     Nested Html Comment
           Second Nesting
   Third Nesting
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<beppo>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Nesting
    Third Nesting
  -->
  <p>para2</p>
</beppo>
HTML
#WSE: default for Html Comments is OIR:loose, allowing any indent
# provided BlockOnsideDemarcation is observed (Offside Rule)
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -11- Mixed Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%pippo
  %p para1
  / Inline comment
    Mixed
      More nested
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<pippo>
  <p>para1</p>
  <!-- Inline comment
    Mixed
    More nested
  -->
  <p>para2</p>
</pippo>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -12- Mixed Content - Haml Comment";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%pluto
  %p para1
  / Inline comment
    Mixed
    -# %p Commented Out
      More nested Haml comment
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<pluto>
  <p>para1</p>
  <!-- Inline comment
    Mixed
    More nested
  -->
  <p>para2</p>
</pluto>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -13- Nesting under another Element";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%blarg
  %p
     para1
     /
        Nested Html Comment
        Second Nesting
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<blarg>
  <p>
    para1
    <!--
      Nested Html Comment
      Second Nesting
    -->
  </p>
  <p>para2</p>
</blarg>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -14- Nesting under another Element - Mixed Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%blech
  %p para1
     /
        Nested Html Comment  
        Second Nesting
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<blech>
  <p>para1
    <!--
      Nested Html Comment
      Second Nesting
    -->
  </p>
  <p>para2</p>
</blech>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -15- Ordinary Inline - commentlexeme";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', clex => "<!-" );
%wibble
  %p para1
  /
    %tags Inline #{clex}-
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<wibble>
  <p>para1</p>
  <!--
    <tags>Inline --><!-- </tags>
  -->
  <p>para2</p>
</wibble>
HTML
#WSE Haml: produce well-formed Html
#
#    Within Haml Comment ContentBlock (WSE Haml)
#    HamlSource                 WSE Haml HtmlOutput
#    (After Interpolation)
#    ---------------------      -------------------
#    /--+>/                     --><!--
#    /<!--+/                    --><!--
#    /-(-+)/                    '-' + ' ' x length $1
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "08HtmlComments -16- Ordinary Inline - commentlexeme - dashes";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', clex => "---" );
%wobble
  %p para1
  /
    %tags Inline -#{clex}
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<wobble>
  <p>para1</p>
  <!--
    <tags>Inline -   </tags> 
  -->
  <p>para2</p>
</wobble>
HTML
#WSE Haml: produce well-formed Html
# "----" => "-   "
}#>>>>>TODO

