#00ImplNotes_Code08_3-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_3
#         spec --color spec/00ImplNotes_Code08_3-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.3-02 -- Elements:" do
  it "Two-line nesting - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%div
  %p
    cblock1
    %span cblock2
HAML
      wspc.html.should == <<'HTML'
<div>
  <p>
    cblock1
    <span>cblock2</span>
  </p>
</div>
HTML
  end
end
#<div>\n  <p>\n    cblock1\n    <span>cblock2</span>\n  </p>\n</div>

