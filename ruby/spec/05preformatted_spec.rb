#05preformatted_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/05preformatted_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

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


#================================================================
describe HamlRender, "-01- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: atag, direct" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code'],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %atag
     Nested lines
       More Nested lines
      Final line
HAML
      wspc.html.should == <<HTML
<div>
   <atag>
      Nested lines
      More Nested lines
      Final line
   </atag>
</div>
HTML
    end
  end
end
#OutputIndentStep = three spaces
#On output, ContentBlock is indented three spaces from Head (atag)
#w/oir=>loose, if CB lines were tags, additional nesting applies
#but with plaintext, it is all just aligned on the OutputIndentStep
#B/c oir=>loose in atag, with plaintext, no leading whitespace.
#
#Same indentation and newline treatment case 02: "ptag, direct",
#  with different tag.


#================================================================
describe HamlRender, "-02- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: ptag, direct" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %ptag
     Nested lines
       More Nested lines
      Final line
HAML
      wspc.html.should == <<HTML
<div>
   <ptag>
      Nested lines
      More Nested lines
      Final line
   </atag>
</div>
HTML
    end
  end
end
#In WSE Haml, an option:preserve tag accepts Nested
# (but not Mixed, as Inline fragement would be confused for legacy-style ptag CB).
#The nested content follows "atag-direct" semantics (above)
#
#Same indentation and newline treatment case 01: "atag, direct",
#  with different tag.


#================================================================
describe HamlRender, "-03- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: vtag, direct" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'pre' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %vtag
     Nested lines
       More Nested lines
      Final line
HAML
      wspc.html.should == <<HTML
<div>
   <vtag>
Nested lines
  More Nested lines
 Final line
   </vtag>
</div>
HTML
    end
  end
end
#A 'vtag' shifts a direct content block to indentation 0
#This is a one of the unique results of these combinations.
#
#Unique rentering among these cases


#================================================================
describe HamlRender, "-04- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: atag, filter:preserve" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code' ],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %atag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <atag>
       Nested lines&#x000A;   More Nested lines&#x000A;  Final line
   </atag>
</div>
HTML
    end
  end
end
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
describe HamlRender, "-05- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: ptag, filter:preserve" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %ptag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <ptag> Nested lines&#x000A;   More Nested lines&#x000A;  Final line</ptag>
</div>
HTML
    end
  end
end
# A unique rendering among these cases


#================================================================
describe HamlRender, "-06- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: vtag, filter:preserve" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %vtag
    :preserve
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <vtag>
 Nested lines&#x000A;   More Nested lines&#x000A;  Final line
   </vtag>
</div>
HTML
    end
  end
end
# Same rendering as: case 08 "ptag, preformatted"
# Rendered very similarly to case 4 "atag, preserve",
# except this case pushes the leading whitespace to column 0.


#================================================================
describe HamlRender, "-07- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: atag, filter:preformatted" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %atag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <atag>
      Nested lines
        More Nested lines
       Final line
   </atag>
</div>
HTML
    end
  end
end
#Notice the first Textline of the ContentBlock -- it starts
#at column seven, just as the prior atag case: two OutputIndentSteps,
#plus the one-space Leading Whitespace.
#
#Unique result
# :preformatted delivers a CB with protection of a 1-space leading whitespace
# and 'atag' positions the CB at the OutputIndentStep from <atag>


#================================================================
describe HamlRender, "-08- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: ptag, filter:preformatted" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %ptag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <ptag>
 Nested lines&#x000A;   More Nested lines&#x000A;  Final line
   </ptag>
</div>
HTML
    end
  end
end
#We get the :preformatted effects, then the ptag preserve effects
#
#Same rendering as: case 06 "vtag, preserve"
#Rendered very similarly to case 4 "atag, preserve", except this case
#pushes the leading whitespace to column 0.


#================================================================
describe HamlRender, "-09- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: vtag, filter:preformatted" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %vtag
    :preformatted
       Nested lines
         More Nested lines
        Final line
HAML
      wspc.html.should == <<HTML
<div>
   <vtag>
 Nested lines
   More Nested lines
  Final line
   </vtag>
</div>
HTML
    end
  end
end
#We get the :preformatted effects (which preserves that leading Whitespace)
#then the vtag preformatted effects (which shifts to 0, but the Leading
#whitespace is preserved)
#
#Unique rendering among these cases


#================================================================
describe HamlRender, "-10- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: atag, HereDoc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %atag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
      wspc.html.should == <<HTML
<div>
   <atag>
       Nested lines
         More Nested lines
        Final line
   </atag>
</div>
HTML
    end
  end
end
#Same as atag w/filter:preformatted
# - atag shifts CB to align on OutputIndentStep
# - CB has one column of Leading Whitespace
#
#Unique


#================================================================
describe HamlRender, "-11- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: ptag, HereDoc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %ptag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
      wspc.html.should == <<HTML
<div>
   <ptag>
     Nested lines&#x000A;       More Nested lines&#x000A;      Final line
   </ptag>
</div>
HTML
    end
  end
end
#Unique case


#================================================================
describe HamlRender, "-12- Preformatted:" do
  it "Tag Category and HtmlOutput Grid: vtag, HereDoc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['textarea', 'code', 'ptag' ],
                 :preformatted => ['ver', 'pre', 'code', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
- html_tabstring('   ')
%div
  %vtag<<-DOC
     Nested lines
       More Nested lines
      Final line
     DOC
HAML
      wspc.html.should == <<HTML
<div>
   <vtag>
     Nested lines
       More Nested lines
      Final line
   </vtag>
</div>
HTML
    end
  end
end
#unique rendering -- verbatim contentblock


#================================================================
describe HamlRender, "-13- Preformatted:" do
  it "%pre +observe BlockOnsideDemarcation, with nested content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['textarea', 'code'],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<'HTML'
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
    end
  end
end
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
describe HamlRender, "-14- Preformatted:" do
  it "%pre +NOTobserve BlockOnsideDemarcation: requires HereDoc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['textarea', 'code'],
                 :preformatted => ['ver', 'pre', 'code'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    end
  end
end
#Note: %pre is in option:preformatted
#WSE Haml: HereDoc provides ContentBlock to option:preformatted tag (vtag)
#  HereDoc assy the CB with leading indents preserved
#  The vtag shifts the CB to Indentation 0
#  (which results in preserved leading whitespace, the indentation replayed)


#================================================================
describe HamlRender, "-15- Preformatted:" do
  it "%pre +NOTobserve BlockOnsideDemarcation: requires HereDoc, using <<-" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['textarea', 'code'],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    end
  end
end


#================================================================
describe HamlRender, "-16- Preformatted:" do
  it "%code Legacy Illeg. Nesting.  option:preformatted over preserve - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['textarea', 'code'],
                 :preformatted => ['ver', 'pre', 'code' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    end
  end
end
