#00ImplNotes_Code03-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_3
#         spec --color spec/00ImplNotes_Code03-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 3-01 -- Shiny Things:" do
  it "gee whiz" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%gee
  %whiz
    Wow this is cool!
HAML
      wspc.html.should == <<HTML
<gee>
  <whiz>
    Wow this is cool!
  </whiz>
</gee>
HTML
  end
end

