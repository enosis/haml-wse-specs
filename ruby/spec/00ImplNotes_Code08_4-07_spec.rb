#00ImplNotes_Code08_4-07_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_4
#         spec --color spec/00ImplNotes_Code08_4-07_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.4-07 -- Indentation:" do
  it "Haml for Canonical Html File" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%html
  %head
  %body
    CONTENT
HAML
      wspc.html.should == <<'HTML'
<html>
  <head></head>
  <body>
    CONTENT
  </body>
</html>
HTML
  end
end
