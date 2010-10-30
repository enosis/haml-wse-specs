#00ImplNotes_Code08_4-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_4
#         spec --color spec/00ImplNotes_Code08_4-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.4-02 -- Indentation:" do
  it "Standard Legacy multiblock indent and undent - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%div
  %div#id1
    %p cblock1
    %div#a
      %p cblock2
      %p
        cblock3
  %div#id2
    %p cblock4
HAML
      wspc.html.should == <<'HTML'
<div>
  <div id='id1'>
    <p>cblock1</p>
    <div id='a'>
      <p>cblock2</p>
      <p>
        cblock3
      </p>
    </div>
  </div>
  <div id='id2'>
    <p>cblock4</p>
  </div>
</div>
HTML
  end
end
#Legacy Haml
#Compare with next spec, Code 8.4-03, which has variable indentation,
#  and the following specs
