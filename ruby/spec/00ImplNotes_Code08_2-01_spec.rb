#00ImplNotes_Code08_2-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_2
#         spec --color spec/00ImplNotes_Code08_2-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.2-01 -- Coarse Hierarchy:" do
  it "Multiline -- Two blocks whiteline demarked" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  First |
  Block |

  Second |
  Block |
HAML
      wspc.html.should == <<'HTML'
<foo>
  First Block
  Second Block
</foo>
HTML
    end
  end
end
#Legacy Haml
#<foo>\n  First Block Second Block \n</foo>
