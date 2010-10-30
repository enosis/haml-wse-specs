#00ImplNotes_Code09_3-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_3
#         spec --color spec/00ImplNotes_Code09_3-02_spec.rb -f s
#
#Authors: 
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

require './HamlRender'


#================================================================
describe HamlRender, "ImplNotes Code 9.3-02 -- Heads:HtmlComment:" do
  it "Producing well-formed Html - improper content - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.zork
  %p para1
  / plaintext html comment
  %p para2
  / comment with embedded --> html comment endtag
  <p>para3</p>
  / comment with embedded <!-- html comment starttag
  <p>para4</p>
  / comment with embedded --- serial hyphens
HAML
      wspc.html.should == <<'HTML'
<div class='zork'>
  <p>para1</p>
  <!-- plaintext html comment -->
  <p>para2</p>
  <!-- comment with embedded --><!-- html comment endtag -->
  <p>para3</p>
  <!-- comment with embedded --><!-- html comment starttag -->
  <p>para4</p>
  <!-- comment with embedded -   serial hyphens -->
</div>
HTML
    end
  end
end
#Legacy Haml:
#<div class='zork'>
#  <p>para1</p>
#  <!-- plaintext html comment -->
#  <p>para2</p>
#  <!-- comment with embedded --> html comment endtag -->
#  <p>para3</p>
#  <!-- comment with embedded <!-- html comment starttag -->
#  <p>para4</p>
#  <!-- comment with embedded --- serial hyphens -->
#</div>
#WSE Haml: produce well-formed Html
#
#    Within Haml Comment ContentBlock (WSE Haml)
#    HamlSource                 WSE Haml HtmlOutput
#    (After Interpolation)
#    ---------------------      -------------------
#    /--+>/                     --><!--
#    /<!--+/                    --><!--
#    /-(-+)/                    '-' + ' ' * $1.length 
