#!/usr/bin/env perl
#
#12heredoc.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/12heredoc.t
#          ./perl $ make heredoc
#
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default
#Notice: Trailing whitespace is present on some Textlines

# See 05preformatted.t for examples of variations on HereDoc and the
# different classes of tags: %atags (ordinary), %ptags (preserve),
# %vtags (preformatted). These tests focus mainly on the syntax, not
# the variety in HtmlOutput.

use strict;
use warnings;

use Test::More tests=>15;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -01- Simple case";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
    %p<<DOC
  HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <bar>
    <p>
        HereDoc Para
    </p>
  </bar>
</foo>
HTML
#Notice: With %atag + HereDoc: The Leading Whitespace is perserved
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -02- Simple case - Indented";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
    %p<<-DOC
  HereDoc Para
  DOC
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <bar>
    <p>
        HereDoc Para
    </p>
  </bar>
</foo>
HTML
#Notice: With %atag + HereDoc: The Leading Whitespace is preserved
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -03- Simple case - With Ruby attributes";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %qux
    %p{:a => 'b'}<<DOC
  HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <qux>
    <p a='b'>
        HereDoc Para
    </p>
  </qux>
</baz>
HTML
#Notice: With %atag + HereDoc: The Leading Whitespace is preserved
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -04- Simple case - White Html attributes";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %qux
    %p(a='b')<<DOC
  HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <qux>
    <p a='b'>
        HereDoc Para
    </p>
  </qux>
</baz>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -05- Simple case - With Ruby attributes, multiple line";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%baz
  %qux
    %p{:a => 'b',
       :y => 'z'}<<DOC
  HereDoc Para
HAML
is($htmloutput, <<HTML, $tname);
<baz>
  <qux>
    <p a='b' y='z'>
        HereDoc Para
    </p>
  </qux>
</baz>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -06- TODO: Possible facility: succeed-like terminator (immediate)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%toto
  %tutu
    %span.red<<DOC.
  HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<toto>
  <tutu>
    <span class='red'>
        HereDoc Para
    </span>.
  </tutu>
</toto>
HTML
#TODO: Candidate facility, not in WSE at this point
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -07- Simple case, with succeed-like terminator (displaced)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%toto
  %tutu
    *
    %span.ital<<DOC *
    HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<toto>
  <tutu>
    *
    <span class='ital'>
          HereDoc Para
    </span> *
  </tutu>
</toto>
HTML
# * <span>...</span> *
#TODO: Candidate facility, not in WSE at this point
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -08- TODO: Candidate capability for succeed-like terminator (interpolated)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', punct =>"..." );
%toto
  %tutu
    %span <<-DOC#{punct}
    HereDoc Para
             DOC
HAML
is($htmloutput, <<HTML, $tname);
<toto>
  <tutu>
    <span>
          HereDoc Para
    </span>...
  </tutu>
</toto>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -09- Simple case, w/whitespace-removal (interior) lexeme";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%zot
  %zap
    %p<<<DOC
  HereDoc Para
  Two Lines
DOC
%p last para
HAML
is($htmloutput, <<HTML, $tname);
<zot>
  <zap>
    <p>  HereDoc Para
        Two Lines</p>
    <p>last para</p>
  </zap>
</zot>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -10- Simple case, w/whitespace-removal (exterior) lexeme";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%zot
  %zap
    %p para1
    %p><<DOC
  HereDoc Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<zot>
  <zap>
    <p>para1</p><p>
        HereDoc Para
    </p>
  </zap>
</zot>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -11- Haml Comments - not recognized (copied thru)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%p para1
%p<<DOC
  HereDoc
  -# hamlcomment
  Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>
    HereDoc
    -# hamlcomment
    Para
</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -12- Interpolation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML', varstr => "   variable2  \n  twolines   " );
%frob
  %zork
    %p para1
    %p<<DOC
  HereDoc
  #{varstr}
  Final
DOC
HAML
is($htmloutput, <<HTML, $tname);
<frob>
  <zork>
    <p>para1</p>
    <p>
        HereDoc
          variable2  
          twolines   
        Final
    </p>
  </zork>
</frob>
HTML
#Notice: Initial whitespace in the interpolated var is wrt indentation
#  of the interop lexeme #{}, so it adds to that indentation.
#  BUT, after newlines, these are wrt
#Not obvious: The trailing whitespace _is_ replayed to HtmlOutput
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -13- No Haml Tag interpretation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%p para1
%p<<DOC
  HereDoc
  %span tag
  Para
DOC
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>
    HereDoc
    %span tag
    Para
</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "12HereDoc -14- With indented Textline following";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%p para1
%p<<-DOC
  HereDoc
     DOC
  %p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>
    HereDoc
</p>
<p>para2</p>
HTML
}#>>>>>TODO


# As noted above, the HereDoc is a method for providing an Element's content;
# where an Element supports HereDocs, that Element's resulting ContentBlock
# (after the HereDoc interpretation, including interpolation) is valid for
# any type of Content Model (Inline, Nested, or Mixed). If, for example, the
# Element's Head is listed in C<option:preserve>, the standard preserve
# transformations will be present in the HtmlOutput.

# The internal details of this are, however, implementation dependent: only
# the HtmlOutput is assured. So, for example, the implementation could use
# a special encoding, or another representation, to effect the required
# results.
