#00ImplNotes_Code09_5-08_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_5
#         spec --color spec/00ImplNotes_Code09_5-08_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.5-08 -- Heads:HereDoc:" do
  it "Case: Exceptions - WSE Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      lambda { wspc.render_haml( <<'HAML', h_opts ) }.should raise_error(Haml::SyntaxError,/Self-closing tag.*content/)
%body
  %dir
    %dir
      %sku/<<DOC
      HereDoc
      DOC
HAML
      wspc.html.should == nil
  end
end
