#!/usr/bin/env perl
#
#03nesting.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/03nesting.t
#          ./perl $ make nesting
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

use Test::More tests=>12;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#================================================================
$tname = "03Nesting -01- Nested Content";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
  Nested Paragraph Text
HAML
is($htmloutput, <<"HTML", $tname);
<p>\n  Nested Paragraph Text\n</p>
HTML


#================================================================
$tname = "03Nesting -02- %p Constant Nesting within plaintext Content";
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
#Note: The trailing spaces on the Textlines are removed, properly-so
# for %p tags (and most, but not all, other tags)


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -03- %p Variable nesting within plaintext content - OIR:strict";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p
  Nested Text1
      Nested Text2
        Nested Text3
             Nested Text4
      Nested Text5
HAML
is($htmloutput, <<HTML, $tname);
<p>\n  Nested Text1\n  Nested Text2\n  Nested Text3\n  Nested Text4\n  Nested Text5\n</p>
HTML
#HamlSource is not in error, even under OIR:strict: variable nesting
#  is permitted, provided that within a ContentBlock, undents must
#  remain 'onside' and 'unfold' the IndentSteps.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -04- %p Variable nesting within plaintext content, unconstrained undent - OIR:loose";
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
#Under OIR:loose, variable nesting (random Undent) is permitted,
#  as long as the undents remain 'onside' the BlockOnsideDemarcation
#See below for case where Textline "Nested Para Text1" is Haml tag
}#>>>>>TODO


#================================================================
$tname = "03Nesting -05- %p Variable nesting within plaintext content, unconstrained undent - OIR:strict - SyntaxError";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
throws_ok { $haml->render(<<'HAML')} 'Haml::SyntaxError','nesting plaintext illegal';
%p
  Nested Para Text1
        Nested Para Text2
     Nested Para Text3
HAML
#is($htmloutput, <<'HTML', $tname);
#HTML
#Under OIR:strict should be ERROR: variable nesting is permitted,
#  but within a ContentBlock, undents must unfold the IndentSteps.
#See below for case where Textline "Nested Para Text1" is Haml tag


#================================================================
$tname = "03Nesting -06- Nested Elements - Legacy Indent - OIR:strict";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
    %baz
      bang
    boom
HAML
is($htmloutput, <<HTML, $tname);
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
#For comparison
#  -- the HtmlOutput should be the same for equiv. IndentStep indentations


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -07- Nested Elements - Variable Indent - OIR:strict";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
      %baz
        bang
      boom
HAML
is($htmloutput, <<HTML, $tname);
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
#Permitted, even under OIR:strict: Undent unfolding honors IndentSteps
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -08- Nested Elements - Variable Indent - OIR:loose";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
      %baz
        bang
      boom
HAML
is($htmloutput, <<HTML, $tname);
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
#Compare with oir:strict, above, and next test
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -09- Nested Elements - Variable Indent, Offside Undent - OIR:loose";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%foo
  %bar
      %baz
        bang
   boom
HAML
is($htmloutput, <<HTML, $tname);
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
#Notice: 'boom' has an IndentStep of one space.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -10- Nested Elements - Expressions - OIR:loose";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%fruit= expr1 "Ora\nnge"
%vege= "Egg\nplant"
%mineral= "Iron"
HAML
is($htmloutput, <<HTML, $tname);
<fruit>__Ora
  nge__
</fruit>
<vege>Egg
  plant
</vege>
<mineral>Iron</mineral>
HTML
#Notice: honors author use of Inline for =expr, so result is tight to tag
# (would preserve/replay any initial whitespace) but recognizes newline 
# -- handles tagend as Nested.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "03Nesting -11- Nested Elements - Expressions mixed with plain text";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'loose' );
$htmloutput = $haml->render(<<'HAML');
%fruit
  = expr1 "Ora\nnge"
  %stone
   even more
     -# Sample Indent

   -#  example "Star"
%Nextitem

   -# Evil indent

%vege Eggplant
HAML
is($htmloutput, <<'HTML', $tname);
<fruit>
  __Ora
  nge__
  <stone>
    even more
  </stone>
</fruit>
<Nextitem></Nestitem>

<vege>Eggplant</vege>
HTML
#Notice:
# =expr is on Nested Line, therefore not run tight
# the Haml comment "-# evil indent", when removed, gives two Whitelines
#   which are collapsed into one whiteline in HtmlOutput
}#>>>>>TODO



