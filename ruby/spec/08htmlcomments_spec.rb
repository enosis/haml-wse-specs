#08htmlcomments_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/08htmlcomments_spec.rb -f s
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
describe HamlRender, "-01- Html Comments" do
  it "Ordinary Inline" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %p para1
  /Inline comment
  %p para2
HAML
      wspc.html.should == <<HTML
<foo>
  <p>para1</p>
  <!-- Inline comment -->
  <p>para2</p>
</foo>
HTML
    #end
  end
end
#Notice: Initial wspc removed


#================================================================
describe HamlRender, "-02- Html Comments" do
  it "Ordinary Nested" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bar
  %p para1
  /
      Nested Html Comment  
  %p para2
HAML
      wspc.html.should == <<HTML
%bar
  <p>para1</p>
  <!--
    Nested Html Comment
  -->
  <p>para2</p>
HTML
    end
  end
end
#Notice: Initial wspc removed for nested too


#================================================================
describe HamlRender, "-03- Html Comments" do
  it "Nested multiple lines -- Consistent indent" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %p para1
  /
     Nested Html Comment  

     Second Nesting Continued
  %p para2
HAML
      wspc.html.should == <<HTML
<baz>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Nesting Continued
  -->
  <p>para2</p>
</baz>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-04- Html Comments" do
  it "Nested multiple lines -- Consistent indent -- Multiple Whitelines" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%qux
  %p para1
  /
     Nested Html Comment  


     Second Nesting Continued
  %p para2
HAML
      wspc.html.should == <<HTML
<qux>
  <p>para1</p>
  <!--
    Nested Html Comment

    Second Nesting Continued
  -->
  <p>para2</p>
</qux>
HTML
    end
  end
end
#WSE: By default, Several consecutive Whitelines in HamlSource 
#     are consolidated to a single whiteline on HtmlOutput.


#================================================================
describe HamlRender, "-05- Html Comments" do
  it "Nesting -- Active Haml Tags" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zork
  %p para1
  /
     Nested Html Comment  
     %p Contained Haml
  %p para2
HAML
      wspc.html.should == <<HTML
<zork>
  <p>para1</p>
  <!--
    Nested Html Comment
    <p>Contained Haml</p>
  -->
  <p>para2</p>
</zork>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-06- Html Comments" do
  it "Nesting -- Active Haml Tags - Haml Comment" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%gork
  %p para1
  /
     Nested Html Comment  
     -#%p Contained Haml
     Second Html Comment
  %p para2
HAML
      wspc.html.should == <<HTML
<gork>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Html Comment
  -->
  <p>para2</p>
</gork>
HTML
    end
  end
end
#Haml comment is recognized too


#================================================================
describe HamlRender, "-07- Html Comments" do
  it "Nesting -- Active Haml Tags - Haml Comment" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bork
  %p para1
  /
     Nested Html Comment  
     -#
       %p Contained Haml
     Second Html Comment
  %p para2
HAML
      wspc.html.should == <<HTML
<bork>
  <p>para1</p>
  <!--
    Nested Html Comment
    Second Html Comment
  -->
  <p>para2</p>
</bork>
HTML
    end
  end
end
# Nested Haml Comment (in any haml tag having Nested/Mixed) will
# observe Offsides and Whiteline delimitation of its Content Block


#================================================================
describe HamlRender, "-08- Html Comments" do
  it "Nested -- Mistaken nested comments" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    end
  end
end
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


#================================================================
describe HamlRender, "-09- Html Comments" do
  it "Nested multiple lines -- Mixed indent - OIR strict" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bingo
  %p para1
  /
     Nested Html Comment  
           Second Nesting
        Third Nesting
  %p para2
HAML
      wspc.html.should == <<HTML
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
    end
  end
end
#WSE: default for Html Comments is OIR:loose, but this example
# is compliant with OIR:strict


#================================================================
describe HamlRender, "-10- Html Comments" do
  it "Nested multiple lines -- Mixed indent - OIR loose (default)" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%beppo
  %p para1
  /
     Nested Html Comment  
           Second Nesting
   Third Nesting
  %p para2
HAML
      wspc.html.should == <<HTML
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
    end
  end
end
#WSE: default for Html Comments is OIR:loose, allowing any indent
# provided BlockOnsideDemarcation is observed (Offside Rule)


#================================================================
describe HamlRender, "-11- Html Comments" do
  it "Mixed Content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%pippo
  %p para1
  / Inline comment
    Mixed
      More nested
  %p para2
HAML
      wspc.html.should == <<HTML
<pippo>
  <p>para1</p>
  <!-- Inline comment 
    Mixed
    More nested
  -->
  <p>para2</p>
</pippo>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-12- Html Comments" do
  it "Mixed Content -- Haml Comment" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%pluto
  %p para1
  / Inline comment
    Mixed
    -# %p Commented Out
      More nested Haml comment
  %p para2
HAML
      wspc.html.should == <<HTML
<pluto>
  <p>para1</p>
  <!-- Inline comment 
    Mixed
    More nested
  -->
  <p>para2</p>
</pluto>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-13- Html Comments" do
  it "Nesting under another Element" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%blarg
  %p
     para1
     /
        Nested Html Comment  
        Second Nesting
  %p para2
HAML
      wspc.html.should == <<HTML
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
    end
  end
end


#================================================================
describe HamlRender, "-14- Html Comments" do
  it "Nesting under another Element - Mixed Content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%blech
  %p para1
     /
        Nested Html Comment  
        Second Nesting
  %p para2
HAML
      wspc.html.should == <<HTML
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
    end
  end
end


#================================================================
describe HamlRender, "-15- Html Comments" do
  it "Ordinary Inline -- commentlexeme" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :clex => "<!-" )
%wibble
  %p para1
  / 
    %tags Inline #{clex}-
  %p para2
HAML
      wspc.html.should == <<HTML
<wibble>
  <p>para1</p>
  <!--
    <tags>Inline --><!-- </tags> 
  -->
  <p>para2</p>
</wibble>
HTML
    end
  end
end
#WSE Haml: produce well-formed Html
#
#    Within Haml Comment ContentBlock (WSE Haml)
#    HamlSource                 WSE Haml HtmlOutput
#    (After Interpolation)
#    ---------------------      -------------------
#    /--+>/                     --><!--
#    /<!--+/                    --><!--
#    /-(-+)/                    '-' + ' ' * $1.length 


#================================================================
describe HamlRender, "-16- Html Comments" do
  it "Ordinary Inline -- commentlexeme - dashes" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :clex => "---" )
%wobble
  %p para1
  / 
    %tags Inline -#{clex}
  %p para2
HAML
      wspc.html.should == <<HTML
<wobble>
  <p>para1</p>
  <!--
    <tags>Inline -   </tags> 
  -->
  <p>para2</p>
</wobble>
HTML
    end
  end
end
#WSE Haml: produce well-formed Html
# "----" => "-   "
