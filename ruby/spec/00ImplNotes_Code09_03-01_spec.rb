#00ImplNotes_Code09_3-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_3
#         spec --color spec/00ImplNotes_Code09_3-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.3-01 -- Heads:HtmlComment:" do
  it "Producing well-formed Html - nested comment - WSE Haml" do
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
  / 
    nested commenting line1 
    / nested commenting line2
  %p para3
HAML
      wspc.html.should == <<'HTML'
<div class='zork'>
  <p>para1</p>
  <!-- plaintext html comment -->
  <p>para2</p>
  <!--
    nested commenting line1
    / nested commenting line2
  <p>para3</p>
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
#  <!--
#    nested commenting line1
#    <!-- nested commenting line2 -->
#  -->
#  <p>para3</p>
#</div>
