#00ImplNotes_Code08_4-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_4
#         spec --color spec/00ImplNotes_Code08_4-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.4-01 -- Indentation:" do
  it "Standard Legacy 2-space IndentStep - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%HEAD1
  %HEAD2
    %HEAD3
      Content1
      Content2
  UNDENTLINE
HAML
      wspc.html.should == <<'HTML'
<HEAD1>
  <HEAD2>
    <HEAD3>
      Content1
      Content2
    </HEAD3>
  </HEAD2>
  UNDENTLINE
</HEAD1>
HTML
  end
end
