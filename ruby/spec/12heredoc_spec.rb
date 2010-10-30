#12heredoc_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/12heredoc_spec.rb -f s
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
describe HamlRender, "-01- HereDoc" do
  it "Simple case" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar
    %p<<DOC
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<foo>
  <bar>
    <p>
        HereDoc Para
    </p>
  </bar>
</foo>
HTML
    end
  end
end
#Notice: With %atag + HereDoc: The Leading Whitespace is perserved


#================================================================
describe HamlRender, "-02- HereDoc" do
  it "Simple case - Indented" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar
    %p<<-DOC
  HereDoc Para
  DOC
HAML
      wspc.html.should == <<HTML
<foo>
  <bar>
    <p>
        HereDoc Para
    </p>
  </bar>
</foo>
HTML
    end
  end
end
#Notice: With %atag + HereDoc: The Leading Whitespace is preserved

#================================================================
describe HamlRender, "-03- HereDoc" do
  it "Simple case - With Ruby attributes" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %qux
    %p{:a => 'b'}<<DOC
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<baz>
  <qux>
    <p a='b'>
      HereDoc Para
    </p>
  </qux>
</baz>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-04- HereDoc" do
  it "Simple case - With Html attributes" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %qux
    %p(a='b')<<DOC
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<baz>
  <qux>
    <p a='b'>
      HereDoc Para
    </p>
  </qux>
</baz>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-05- HereDoc" do
  it "Simple case - With Ruby attributes, multiple line" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %qux
    %p{:a => 'b',
       :y => 'z'}<<DOC
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<baz>
  <qux>
    <p a='b' y='z'>
      HereDoc Para
    </p>
  </qux>
</baz>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-06- HereDoc" do
  it "TODO: Possible facility: succeed-like terminator (immediate)" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%toto
  %tutu
    %span.red<<DOC.
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<toto>
  <tutu>
    <span class='red'>
      HereDoc Para
    </span>.
  </tutu>
</toto>
HTML
    end
  end
end
#TODO: Candidate facility, not in WSE at this point


#================================================================
describe HamlRender, "-07- HereDoc" do
  it "Simple case, with succeed-like terminator (displaced)" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%toto
  %tutu
    *
    %span.ital<<DOC *
    HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<toto>
  <tutu>
    *
    <span class='ital'>
      HereDoc Para
    </span> *
  </tutu>
</toto>
HTML
    end
  end
end
# * <span>...</span> *
#TODO: Candidate facility, not in WSE at this point


#================================================================
describe HamlRender, "-08- HereDoc" do
  it "TODO: Candidate capability for succeed-like terminator (interpolated)" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :punct => "..." )
%toto
  %tutu
    %span <<-DOC#{punct}
    HereDoc Para
             DOC
HAML
      wspc.html.should == <<HTML
<toto>
  <tutu>
    <span>
      HereDoc Para
    </span>...
  </tutu>
</toto>
HTML
    end
  end
end
# * <span>...</span> *
#TODO: Candidate facility, not in WSE at this point


#================================================================
describe HamlRender, "-09- HereDoc" do
  it "Simple case, with whitespace-removal (interior) lexeme" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  %zap
    %p<<<DOC
  HereDoc Para
  Two Lines
DOC
%p last para
HAML
      wspc.html.should == <<HTML
<zot>
  <zap>
    <p>  HereDoc Para
      Two Lines</p>
    <p>last para</p>
  </zap>
</zot>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-10- HereDoc" do
  it "Simple case, with whitespace-removal (exterior) lexeme" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  %zap
    %p para1
    %p><<DOC
  HereDoc Para
DOC
HAML
      wspc.html.should == <<HTML
<zot>
  <zap>
    <p>para1</p><p>
        HereDoc Para
    </p>
  </zap>
</zot>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-11- HereDoc" do
  it "Haml Comments -- not recognized (copied through)" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%p<<DOC
  HereDoc
  -# hamlcomment 
  Para
DOC
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>
    HereDoc
    -# hamlcomment
    Para
</p>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-12- HereDoc" do
  it "Interpolation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "   variable2  \n  twolines   " )
%frob
  %zork
    %p para1
    %p<<DOC
  HereDoc
  #{varstr} 
  Final
DOC
HAML
      wspc.html.should == <<HTML
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
    end
  end
end
#Notice: Initial whitespace in the interpolated var is wrt indentation
#  of the interop lexeme #{}, so it adds to that indentation.
#  BUT, after newlines, these are wrt 
#Not obvious: The trailing whitespace _is_ replayed to HtmlOutput


#================================================================
describe HamlRender, "-13- HereDoc" do
  it "No Haml Tag interpretation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%p<<DOC
  HereDoc
  %span tag
  Para
DOC
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>
  HereDoc
  %span tag
  Para
</p>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-14- HereDoc" do
  it "HereDoc with indented Textline following" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%p<<-DOC
  HereDoc
     DOC
  %p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>
  HereDoc
</p>
<p>para2</p>
HTML
    end
  end
end


=begin doc

As noted above, the HereDoc is a method for providing an Element's content; 
where an Element supports HereDocs, that Element's resulting ContentBlock
(after the HereDoc interpretation, including interpolation) is valid for 
any type of Content Model (Inline, Nested, or Mixed). If, for example, the 
Element's Head is listed in C<option:preserve>, the standard preserve 
transformations will be present in the HtmlOutput.

The internal details of this are, however, implementation dependent: only 
the HtmlOutput is assured. So, for example, the implementation could use
a special encoding, or another representation, to effect the required
results.

=end
