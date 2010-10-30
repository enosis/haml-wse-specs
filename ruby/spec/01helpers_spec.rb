#01helpers_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/01helpers_spec.rb -f s
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
describe HamlRender, "-01- Helpers:" do
  it "html_indent -- WSE alias for haml_indent" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= haml_indent.length
%p #{haml_indent}
%p abc#{haml_indent}def
%code #{haml_indent}
%ver #{haml_indent}
%p= html_indent.length
%p= uvw#{html_indent}xyz
HAML
      wspc.html.should == <<HTML
<p>2</p>
<p></p>
<p>abc  def</p>
<code>  </code>
<ver>  
</ver>
<p>2</p>
<p>uvw  xyx</p>
HTML
    end
  end
end
#Notice:
# - haml_indent.length is 2 even though the then-current element will receive 
#   no OutputIndent
# - For a non-preserve/non-preformatted tag, the whitespace-only tag in HamlSource
#   is generated as an empty Html element in the HtmlSource
# - For a whitespace-only preserve/preformatted tag, the whitespace is replayed in
#   the HtmlSource. Preserve tags are rendered horizontally; preformatted tags
#   are rendered vertically. An Inline fragment is rendered following the start tag


#================================================================
describe HamlRender, "-02- Helpers:" do
  it "capture_html -- WSE alias for capture_haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
- foo = capture_haml("Foo\n<atag>bar\nbaz</atag>") do |a|
  %tag= a
.toto
  %div
    #{foo}
- foo = capture_html("Foo\n<atag>bar\nbaz</atag>") do |a|
  %tag= a
.tutu
  %div
    #{foo}
HAML
      wspc.html.should == <<HTML
<div class='toto'>
  <div>
    <tag>
      Foo\n      <atag>bar\n      baz</atag>
    </tag>
  </div>
</div>
<div class='tutu'>
  <div>
    <tag>
      Foo\n      <atag>bar\n      baz</atag>
    </tag>
  </div>
</div>
HTML
    end
  end
end
#WSE proposed alias for capture_haml


#================================================================
describe HamlRender, "-03- Helpers:" do
  it "html_concat -- WSE alias for haml_concat" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.foo
  .bar
    - haml_concat("<tag>  fred\nbarney  </tag>")
.baz
  .zot
    - html_concat("<tag>  spam\neggs  </tag>")
HAML
      wspc.html.should == <<HTML
<div class='foo'>
  <div class='bar'>
    <tag>  fred
    barney  </tag>
  </div>
</div>
<div class='baz'>
  <div class='zot'>
    <tag>  spam
    eggs  </tag>
  </div>
</div>
HTML
    end
  end
end
#WSE proposed alias for haml_concat
#DocBUG: haml_concat says "outputs text" (meaning param text) directly
# to buffer, with proper indentation
#What is meant: haml_concat inserts into the HtmlOutput buffer a line
# containing param, with proper indentation
#
#Notice: The inserted OutputIndent following the newline
#(Also:Leading and Trailing whitespace is replayed into HtmlOutput)


#================================================================
describe HamlRender, "-04- Helpers:" do
  it "html_concat -- WSE alias for haml_concat" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit Apples
%vege
  Carrots
  - html_concat(" * " * 2)
  %starch/
HAML
      wspc.html.should == <<HTML
<fruit>Apples</fruit>
<vege>
  Carrots
   *  * 
  <starch />
</vege>
HTML
    end
  end
end
#WSE proposed alias for haml_concat
#Notice: html_concat/haml_concat maintains proper indentation


#================================================================
describe HamlRender, "-05- Helpers:" do
  it "html_tag -- WSE alias for haml_tag" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
- haml_tag :table do
  - haml_tag :tr do
    - haml_tag 'td.cell' do
      - haml_tag :strong, "strong!"
      - haml_concat "data"
- html_tag :table do
  - html_tag :tr do
    - html_tag 'td.cell' do
      - html_tag :strong, "sweet!"
      - html_concat "candy"
HAML
      wspc.html.should == <<HTML
<table>
  <tr>
    <td class='cell'>
      <strong>strong!</strong>
      data
    </td>
  </tr>
</table>
<table>
  <tr>
    <td class='cell'>
      <strong>sweet!</strong>
      candy
    </td>
  </tr>
</table>
HTML
    end
  end
end
#WSE proposed alias for haml_tag


#================================================================
describe HamlRender, "-06- Helpers:" do
  it "html_tabs -- WSE proposed function" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_tabs
.n1
  %p= html_tabs
.n2
  .n2a
    %p= html_tabs
HAML
      wspc.html.should == <<HTML
<p>1</p>
<div id='n1'>
  <p>1</p>
</div>
<div id='n2'>
  <div id='n2a'>
    <p>2</p>
  </div>
</div>
HTML
    end
  end
end
#WSE proposed function
#The number of OutputIndentSteps for next indented line
# (aka: haml_buffer.tabulation)
# html_tabstring * html_tabs => html_indent (OutputIndent)


#================================================================
describe HamlRender, "-07- Helpers:" do
  it "html_tabstring -- WSE proposed get/set function" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_tabstring
- html_tabstring('..')
%p= html_tabstring
%p
  %div#id1
    %p cblock1
    %div#a
      %p cblock2
HAML
      wspc.html.should == <<HTML
<p>  </p>
<p>..</p>
<p>
..<div id='#id1'>
....<p>cblock2</p>
....<div id='a'>
......<p>cblock2</p>
....</div>
..</div>
</p>
HTML
    end
  end
end
#WSE proposed function
#The string used for a single OutputIndentStep. Default: "  "
# (aka: '  ' constant buried in helpers.rb "haml_indent")
#
# html_tabstring * html_tabs => html_indent (OutputIndent)
# (html_tabs: aka: haml_buffer.tabulation)
#
#Setter: sets the html_tabstring


#================================================================
describe HamlRender, "-08- Helpers:" do
  it "html_escape -- WSE enhanced function - escape_html:false" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
      wspc.html.should == <<HTML
<p>Any &lt; string &amp; data &amp; &apos; apostrophe</p>\n
HTML
    end
  end
end
#WSE proposed function
#legacy haml: option:escape_html => false
#legacy: "<p>Any &lt; string &amp; data &amp;amp; ' apostrophe</p>\n"
#Below in next test:
#legacy haml: option:escape_html => true
#legacy: "<p>Any &amp;lt; string &amp;amp; data &amp;amp;amp; ' apostrophe</p>\n"
#
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: &apos;


#================================================================
describe HamlRender, "-09- Helpers:" do
  it "html_escape -- WSE enhanced function - escape_html:true" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
      wspc.html.should == <<HTML
<p>Any &lt; string &amp; data &amp; &apos; apostrophe</p>\n
HTML
    end
  end
end
#WSE proposed function
#legacy haml: option:escape_html => true
#legacy: "<p>Any &amp;lt; string &amp;amp; data &amp;amp;amp; ' apostrophe</p>\n"
#See above, in prior test:
#legacy haml: option:escape_html => false
#legacy: "<p>Any &lt; string &amp; data &amp;amp; ' apostrophe</p>\n"
#
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: &apos;


#================================================================
describe HamlRender, "-10- Helpers:" do
  it "html_escape -- WSE enhanced function - escape_html:false, format:html4" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, :format => :html4,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_escape("Any < string & data &amp; ' apostrophe")
HAML
      wspc.html.should == <<'HTML'
<p>Any &lt; string &amp; data &amp; ' apostrophe</p>
HTML
    end
  end
end
#WSE proposed function
#Notice: Under WSE Haml, where requested, escaping in HtmlOutput is 'proper'.
#This means that the result of this helper is unchanged by option escape_html.
#Notice: Unless specified as option:html4, you get XML escaping: ' &apos;


#================================================================
describe HamlRender, "-11- Helpers:" do
  it "escape_html &= escape_once -- WSE extended functions - escape_html=>true" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, 'str' => <<'STR' )
%p= "#{str}"
%p= escape_once("#{str}")
%p&= "#{str}"
HAML
<script>alert("I'm evil!"); & &amp; not</script>
STR
      wspc.html.should == <<HTML
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
HTML
    end
  end
end
#WSE extended function -- idempotent escaping for proper HtmlOutput, &apos; 
#From the Haml Reference
#
#Legacy Haml -- escape_html=>true
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>
#<p>&amp;lt;script&amp;gt;alert(&amp;quot;I'm evil!&amp;quot;); &amp;amp; &amp;amp; not&amp;lt;/script&amp;gt;</p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>


#================================================================
describe HamlRender, "-12- Helpers:" do
  it "escape_html &= escape_once -- WSE extended functions - escape_html=>false" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, 'str' => <<'STR' )
%p= "#{str}"
%p= escape_once("#{str}")
%p&= "#{str}"
HAML
<script>alert("I'm evil!"); & &amp; not</script>
STR
      wspc.html.should == <<'HTML'
<p><script>alert("I'm evil!"); & &amp; not</script></p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
<p>&lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
HTML
    end
  end
end
#WSE extended function -- idempotent escaping for proper HtmlOutput, &apos; 
#From the Haml Reference
#
#Legacy Haml -- escape_html=>false
#<p><script>alert(\"I'm evil!\"); & &amp; not</script></p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp; not&lt;/script&gt;</p>
#<p>&lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;</p>


#================================================================
describe HamlRender, "-13- Helpers:" do
  it "filter:escapehtml -- WSE Haml alias for filter:escaped" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.foogle
  :escaped
    <script>alert("I'm evil!"); & &amp; not</script>
.boogle
  :escapehtml
    <script>alert("I'm evil!"); & &amp; not</script>
HAML
      wspc.html.should == <<'HTML'
<div class='foogle'>
  &lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;
</div>
<div class='boogle'>
  &lt;script&gt;alert(&quot;I&apos;m evil!&quot;); &amp; &amp; not&lt;/script&gt;
</div>
HTML
    end
  end
end
#WSE enhanced filter:escaped and the WSE alias
#legacy haml:
# &lt;script&gt;alert(&quot;I'm evil!&quot;); &amp; &amp;amp; not&lt;/script&gt;
