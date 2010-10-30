#00ImplNotes_Code04-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_4
#         spec --color spec/00ImplNotes_Code04-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 4-03 -- Motivation:" do
  it "Nex3 Issue 28 - Inconsistent indentation - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      lambda {wspc.render_haml( <<'HAML', h_opts )}.should raise_error(Haml::SyntaxError,/Inconsistent indentation/)
%foo
    up four spaces
  down two spaces
HAML
      wspc.html.should == nil
  end
end
#Legacy Haml
#Inconsistent indentation: 2 spaces were used for indentation, 
#    but the rest of the document was indented using 4 spaces.
#In WSE Haml, this spec should 'fail' because it will not raise the SyntaxError
#For WSE Haml spec, see next spec: Code 4-04
