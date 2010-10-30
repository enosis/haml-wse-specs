#00ImplNotes_Code07-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_7
#         spec --color spec/00ImplNotes_Code07-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 7-02 -- WSE In Brief:" do
  it "Irregular UNDENT - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%div#id1
    %p cblock2 
       cblock4 nested
    %p cblock3
  %p cblock4
HAML
      wspc.html.should == <<HTML
<div id='id1'>
  <p>cblock2
    cblock4 nested
  </p>
  <p>cblock3</p>
  <p>cblock4</p>
</div>
HTML
    end
  end
end
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml: Conceptually after modification to Code 7-01
# Under oir:loose, Offside controls Content Block memberships
#   i.o.w: Within an Element, undents can be irregular/arbitrary
# So, "%p cblock4" is a sibling to "%p cblock2" and "%p cblock3"
