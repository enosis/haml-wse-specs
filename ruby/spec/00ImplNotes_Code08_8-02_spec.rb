#00ImplNotes_Code08_8-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-02 -- Normalizing:" do
  it "Mixed Content - ContentBlock from Multiline Content Block" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%div
  %p First line  |
     Second line |
HAML
      wspc.html.should == <<'HTML'
<div>
  <p>First line Second line</p>
</div>
HTML
    end
  end
end
#Legacy Haml:
#<div>\n  <p>First line  Second line</p>\n</div>
#WSE Haml:
# Equiv Legacy Haml, with whitespace adjustment


