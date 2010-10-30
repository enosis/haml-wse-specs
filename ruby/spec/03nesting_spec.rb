#03nesting_spec.rb
#./haml-wse-specs/ruby/spec
#Calling: spec --color spec/03nesting_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

def expr1(arg = "expr1arg" )
  "__" + arg + "__"
end

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines


#================================================================
describe HamlRender, "-01- Nested Content:" do
  it "%p Nested Content" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Paragraph Text
HAML
      wspc.html.should == <<"HTML"
<p>\n  Nested Paragraph Text\n</p>
HTML
  end
end


#================================================================
describe HamlRender, "-02- Nested Content:" do
  it "%p Constant Nesting within plaintext Content" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Para Text1  
  Nested Para Text2  
  Nested Para Text3  
HAML
      wspc.html.should == <<HTML
<p>\n  Nested Para Text1\n  Nested Para Text2\n  Nested Para Text3\n</p>
HTML
  end
end
#Note: The trailing spaces on the Textlines are removed, properly-so
# for %p tags (and most, but not all, other tags)


#================================================================
describe HamlRender, "-03- Nested Content:" do
  it "%p Variable nesting within plaintext content - OIR:strict" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Text1  
      Nested Text2  
        Nested Text3
             Nested Text4
      Nested Text5
HAML
      wspc.html.should == <<HTML
<p>\n  Nested Text1\n  Nested Text2\n  Nested Text3\n  Nested Text4\n  Nested Text5\n</p> 
HTML
    end
  end
end
#HamlSource is not in error, even under OIR:strict: variable nesting 
#  is permitted, provided that within a ContentBlock, undents must 
#  remain 'onside' and 'unfold' the IndentSteps.


#================================================================
describe HamlRender, "-04- Nested Content:" do
  it "%p Variable nesting within plaintext content, unconstrained undent - OIR:loose" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Para Text1  
        Nested Para Text2  
     Nested Para Text3
HAML
      wspc.html.should == <<HTML
<p>\n  Nested Para Text1\n  Nested Para Text2\n  Nested Para Text3\n</p>
HTML
    end
  end
end
#Under OIR:loose, variable nesting (random Undent) is permitted,
#  as long as the undents remain 'onside' the BlockOnsideDemarcation 
#See below for case where Textline "Nested Para Text1" is Haml tag


#================================================================
describe HamlRender, "-05- Nested Content:" do
  it "%p Variable nesting within plaintext Content, unconstrained undent - OIR:strict - SyntaxError" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      lambda {wspc.render_haml( <<'HAML', h_opts )}.should raise_error(Haml::SyntaxError,/nesting.*plain text.*illegal/)
%p
  Nested Para Text1  
        Nested Para Text2  
     Nested Para Text3
HAML
  end
end
#Under OIR:strict should be ERROR: variable nesting is permitted, 
#  but within a ContentBlock, undents must unfold the IndentSteps.
#See below for case where Textline "Nested Para Text1" is Haml tag


#================================================================
describe HamlRender, "-06- Nested Content:" do
  it "Nested Elements - Legacy Indent - OIR:strict" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar 
    %baz
      bang
    boom
HAML
      wspc.html.should == <<HTML
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
    #end
  end
end
#For comparison
#  -- the HtmlOutput should be the same for equiv. IndentStep indentations


#================================================================
describe HamlRender, "-07- Nested Content:" do
  it "Nested Elements - Variable Indent - OIR:strict" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar 
      %baz
        bang
      boom
HAML
      wspc.html.should == <<HTML
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
    end
  end
end
#Permitted, even under OIR:strict: Undent unfolding honors IndentSteps


#================================================================
describe HamlRender, "-08- Nested Content:" do
  it "Nested Elements - Variable Indent - OIR:loose" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar 
      %baz
        bang
      boom
HAML
      wspc.html.should == <<HTML
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
    end
  end
end
#Compare with oir:strict, above, and next test


#================================================================
describe HamlRender, "-09- Nested Content:" do
  it "Nested Elements - Variable Indent - Offside Undent - OIR:loose" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar  
      %baz
        bang  
   boom
HAML
      wspc.html.should == <<HTML
<foo>\n  <bar>\n    <baz>\n      bang\n    </baz>\n    boom\n  </bar>\n</foo>
HTML
    end
  end
end
#Notice: 'boom' has an IndentStep of one space.


#================================================================
describe HamlRender, "-10- Nested Content:" do
  it "Nested Elements - Expressions - oir:loose" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit= expr1 "Ora\nnge"
%vege= "Egg\nplant"
%mineral= "Iron"
HAML
      wspc.html.should == <<HTML
<fruit>__Ora
  nge__
</fruit>
<vege>Egg
  plant
</vege>
<mineral>Iron</mineral>
HTML
    end
  end
end
#Notice: honors author use of Inline for =expr, so result is tight to tag
# (would preserve/replay any initial whitespace) but recognizes newline 
# -- handles tagend as Nested.


#================================================================
describe HamlRender, "-11- Nested Content:" do
  it "Nested Elements - Expression mixed with plain text" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<'HTML'
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
    end
  end
end
#Notice: 
# =expr is on Nested Line, therefore not run tight
# the Haml comment "-# evil indent", when removed, gives two Whitelines
#   which are collapsed into one whiteline in HtmlOutput
