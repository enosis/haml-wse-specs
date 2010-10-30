#07hamlcomments_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/07hamlcomments_spec.rb -f s
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
describe HamlRender, "-01- Haml Comments" do
  it "Ordinary Inline Content" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %p para1
  -# Inline comment
  %p para2
HAML
      wspc.html.should == <<HTML
<foo>
  <p>para1</p>
  <p>para2</p>
</foo>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-02- Haml Comments" do
  it "Ordinary Mixed Content" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bar
  %p para1
  -# Inline comment
    Nested cont
  %p para2
HAML
      wspc.html.should == <<HTML
<bar>
  <p>para1</p>
  <p>para2</p>
</bar>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-03- Haml Comments" do
  it "Ordinary Mixed Content - Orderly Indentation" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%baz
  %p para1
  -# Inline comment
    Nested cont
      Indented
  %p para2
HAML
      wspc.html.should == <<HTML
<baz>
  <p>para1</p>
  <p>para2</p>
</baz>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-04- Haml Comments" do
  it "Ordinary Mixed Content - Not Orderly Indentation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fum
  %p para1
  -# Inline comment
        Nested cont
      Indented
  %p para2
HAML
      wspc.html.should == <<HTML
<fum>
  <p>para1</p>
  <p>para2</p>
</fum>
HTML
    end
  end
end
#WSE: WSExtensions permit any indentation in HamlComments, provided 
#     the contentblock abides Offside Rule at preset BOD (Head+1)


#================================================================
describe HamlRender, "-05- Haml Comments" do
  it "Ordinary Mixed Content - SubElement" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%qux
  %p para1
  #id1
     -# Inline comment
        Nested comment
  %p para2
HAML
      wspc.html.should == <<HTML
<qux>
  <p>para1</p>
  <div id='id1'></div>
  <p>para2</p>
</qux>
HTML
    end
  end
end
#Legacy permits sub-Element Haml comments
#But legacy Haml (improperly) processes Haml Comment CommentBlock
#  as if HamlComments are member of set of producing tags
#  That is: as a ISWIM lang, only the fact that there is 
#   _indentation_ should matter to HamlComments (which cannot contain
#   sub-Elements) not the amount of indentation.
#BUG: Also, legacy Haml notices too late that the div#id1 contentblock
#  is empty, and thus should be rendered <starttag><endtag> rather
#  than stacked, as if containing nested content.


#================================================================
describe HamlRender, "-06- Haml Comments" do
  it "Ordinary Mixed Content - SubElement - Not Orderly Indentation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bongo
  %p para1
  #id1
     -# Inline comment
           Nested cont
      Indented
  %p para2
HAML
      wspc.html.should == <<HTML
<bongo>
  <p>para1</p>
  <div id='id1'></div>
  <p>para2</p>
</bongo>
HTML
    end
  end
end
#WSE: WSExtensions permit any indentation, provided abides BOD/Offside Rule


#================================================================
describe HamlRender, "-07- Haml Comments" do
  it "Haml Comment inside Multiline" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zork
  First line |
  Second line |
  -#Third line |
  Last line |
  Next Content Block
HAML
      wspc.html.should == <<HTML
<zork>
  First line Second line 
  Last line
  Next Content Block
</zork>
HTML
    end
  end
end
#Haml comment (which is "Haml-inactive") should be removed before 
#Haml-active HamlSource is processed. An author would expect any
#content on a Haml Comment line to be inert.
#However, for backward compatibility, the Haml Comment will
#interrupt a Multiline 
# ... and for sensible least-surprise, EVEN within a Multiline lexeme.


#================================================================
describe HamlRender, "-08- Haml Comments" do
  it "Haml Comment Between Multiline - Backward Compatibility" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%gork
  First line  |
  Second line |
  -#Third line
  Last line   |
  Next Content Block
HAML
      wspc.html.should == <<HTML
<gork>
  First line Second line
  Last line
  Next Content Block
</gork>
HTML
    end
  end
end
#Backward compatibility -- WSE works like legacy
#but prefer correcting this: HamlComment should be invisible
#BUG Legacy Haml: in WSE, removing the extra trailing whitespaces


#================================================================
describe HamlRender, "-09- Haml Comments" do
  it "Haml Comment in Html Comment" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bork
  %p Para
  / 
    First line
    Second line
    -#Third line
    Last line
  Next Content Block
HAML
      wspc.html.should == <<HTML
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
    #end
  end
end
# Works b/c this Html Comment ContentBlock observes OIR:legacy


#================================================================
describe HamlRender, "-10- Haml Comments" do
  it "Haml Comment (Inline) within Nested Html Comment" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p Para
/ 
  First line
  Second line
  -#Third line
    Last line
Next Content Block
HAML
      wspc.html.should == <<HTML
<p>Para</p>
<!--
  First line
  Second line
  Last line
-->
Next Content Block
HTML
    end
  end
end
#WSE extension/interpretation:
#This is a case of resolving ambiguity by reference to priority
#Html Comments are semantic; Haml Comments are not.
#The Html Comment Nested Content Block extends (by Offsides) through 
#to the end of "Last line". Here the Haml Comment Inline Content
#can be, and should be, interpreted in its minimum extent. 
#Therefore the extent of the contained-Haml Comment is the one line.


#================================================================
describe HamlRender, "-11- Haml Comments" do
  it "Haml Comment (Nested) within Nested Html Comment" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
<spam>
  <p>Para</p>
  <!--
    First line
    Second line
  -->
  Next Content Block
</spam>
HTML
    end
  end
end
#By comparison to the above, this RSpec shows how the minimum extent of 
#  the Haml Comment must be interpreted under Nesting Content rules 
#  ... so a new BOD is established and prevails until Offsides or Whiteline
#  (see below) 
#Authors have two ways of commenting-out in such contexts, including
#  'ordinary' Haml tags (%p, etc).


#================================================================
describe HamlRender, "-12- Haml Comments" do
  it "Ordinary Mixed Content - Haml Comment nested called Mixed" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%eggs
  %p para1
  %p para2

    -# Inline comment
HAML
      wspc.html.should == <<HTML
<eggs>
  <p>para1</p>
  <p>para2</p>
</eggs>
HTML
    end
  end
end
#Bug: Haml comments should be removed before considering content
#Adding that interceding Whiteline doesn't defang syntax error 
# (just as would be the case in the Haml comment were, instead, plain text)
#This produces results different than expected under text::haml t/comments.t


#================================================================
describe HamlRender, "-13- Haml Comments" do
  it "Ordinary Mixed Content - SubElement - Sibling" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bac
  %p para1
  #id1
     -#Inline comment
        Nested cont


        %sub/
  %p para2
HAML
      wspc.html.should == <<HTML
<bac>
  <p>para1</p>
  <div id='id1'>

    <sub />
  </div>
  <p>para2</p>
</bac>
HTML
    end
  end
end
#WSE: Whiteline should break Haml Comments
#Accounting for WSE Whiteline consolidating multiple whiteline,
#there's ends up on HtmlOutput one whiteline then the empty <sub />
