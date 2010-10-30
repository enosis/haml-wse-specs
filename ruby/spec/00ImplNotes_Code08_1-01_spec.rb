#00ImplNotes_Code08_1-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_1
#         spec --color spec/00ImplNotes_Code08_1-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.1-01 -- Lexing and Syntactics:" do
  it "Haml-as a Macro Language -- lexer tolerance" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      lambda {wspc.render_haml( <<'HAML' , h_opts, 'varstr' => 'TextStr' )}.should raise_error(Haml::SyntaxError,/Unbalanced brackets/)
%div
    %p #{varstr
HAML
      wspc.html.should == nil
  end
end
