#06mixedcontent_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/06mixedcontent_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines


#================================================================
describe HamlRender, "-01- Mixed Content:" do
  it "Inline" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %p Inline content
HAML
      wspc.html.should == <<HTML
<foo>
  <p>Inline content</p>
</foo>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-02- Mixed Content:" do
  it "Nested" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %p
    Nested content
HAML
      wspc.html.should == <<HTML
<foo>
  <p>
    Nested content
  </p>
</foo>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-03- Mixed Content:" do
  it "Inline plus Nested - HtmlOutput Mixed -- the chosen alt" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "Inline content\nNested content" )
%foo
  %p Inline content
    Nested content
%bar
  %p #{varstr}
HAML
      wspc.html.should == <<HTML
<foo>
  <p>Inline content
    Nested content
  </p>
</foo>
<bar>
  <p>Inline content
    Nested content
  </p>
</bar>
HTML
    end
  end
end
#Choosing model for rendering Mixed Content: compact, or all nested
#This is less attractive, but it has advantages:
# 1. it better reflects the author input
# 2. which results in better locating in the Html
# 3. and results in less fooling with line numbers in case of maintenance
# 4. But makes it difficult to abide by some arbitrary Html coding standards
#This seems a nice direct way to keep (in HtmlOutput) that compact form, 
#  with the Inline line on the tag line.
#Okay, for (a) compactness, (b) limited clean alt, (c) ack. author control, 
#  (d) tag sensitivity, (e) parallel to cases with newline:
#  Use this alt: Mixed in HtmlOutput. 


#================================================================
describe HamlRender, "-04- Mixed Content:" do
  it "Inline plus Nested - HtmlOutput Nested -- discarded alt. rendering -- SHOULDNOT" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "Inline content\nNested content" )
%foo
  %p Inline content
    Nested content
%bar
  %p #{varstr}
HAML
      wspc.html.should_not == <<HTML
<foo>
  <p>
    Inline content
    Nested content
  </p>
</foo>
<bar>
  <p>
    Inline content
    Nested content
  </p>
</bar>
HTML
    end
  end
end
#WSE Haml -- Discarded alt for rendering Mixed (and interp/inline w/newline):
# More attractive HtmlOutput
#  and makes it easier to abide by some Html coding standards
#One dis: other methods of author input to achieve compact form in HtmlOutput
# are crufty (i.e., Perl-like) and have undesirable side-effect on endtag


#================================================================
describe HamlRender, "-05- Mixed Content:" do
  it "Hierarchical Nested, Child Nested" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%div 
  Nested div content
  %p 
    Nested para content
HAML
      wspc.html.should == <<HTML
<div>
  Nested div content
  <p>
    Nested para content
  </p>
</div>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-06- Mixed Content:" do
  it "Hierarchical Nested, Child Nested w/ Inline Content" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%div 
  Nested div content
  %p Nested para, Inline content
HAML
      wspc.html.should == <<HTML
<div>
  Nested div content
  <p>Nested para, Inline content</p>
</div>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-07- Mixed Content:" do
  it "Hierarchical Nested, Both Inline Content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%div Inline div content
  %p Nested para, Inline content
HAML
      wspc.html.should == <<HTML
<div>Inline div content
  <p>Nested para, Inline content</p>
</div>
HTML
    end
  end
end
#Legacy: Fails on %div having Mixed Content


#================================================================
describe HamlRender, "-08- Mixed Content:" do
  it "Hierarchical Nested, Parent Empty, Child Mixed" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%div
  %p Nested para, Inline content
    Nested Content
HAML
      wspc.html.should == <<HTML
<div>
  <p>Nested para, Inline content
    Nested Content
  </p>
</div>
HTML
    end
  end
end
#For comparison
#Legacy: Fails in same way as above, for Mixed Content in %p


#================================================================
describe HamlRender, "-09- Mixed Content:" do
  it "Inline plus Nested - HtmlOutput Mixed (CHOSEN) -- leading wspc -- baseline" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %p= "  Inline  "
HAML
      wspc.html.should == <<HTML
<baz>
  <p>  Inline</p>
</baz>
HTML
    #end
  end
end
#Notice:
#Initial wspc: Even tho' for <p> is useless, copied through
#Trailing wspc dropped (non-preserve/non-preformatted)


#================================================================
describe HamlRender, "-10- Mixed Content:" do
  it "Inline plus Nested - HtmlOutput Mixed (CHOSEN) -- leading wspc COPIED in Interpolation" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "  Inline  " )
%qux
  %p #{varstr}
HAML
      wspc.html.should == <<HTML
<qux>
  <p>  Inline</p>
</qux>
HTML
    #end
  end
end
#WSE: Interpolation gives same result here as it would for actual Inline quoted text.


#================================================================
describe HamlRender, "-11- Mixed Content:" do
  it "Inline plus Nested - HtmlOutput Mixed (CHOSEN) -- leading wspc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bar
  %p= "  Inline  "
         Nested  
HAML
      wspc.html.should == <<HTML
<bar>
  <p>  Inline
    Nested
  </p>
</bar>
HTML
    end
  end
end
#Notice:
#Inline: wspc copied through; trailing wspc lost
#Nested: Initial wspc is HamlSource IndentStep, 
#    converted to single 'tab' (OutputIndentStep) in HtmlOutput


#================================================================
describe HamlRender, "-12- Mixed Content:" do
  it "Nested Interpolation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "  Inline  \n       Nested  " )
%tutu
  %p #{varstr}
HAML
      wspc.html.should == <<HTML
<tutu>
  <p>  Inline
    Nested
  </p>
</tutu>
HTML
    end
  end
end
#For comparison
#Legacy:
#<tutu>
#  <p>
#      Inline  \n           Nested\n  </p>
#</tutu>

