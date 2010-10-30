#00ImplNotes_Code08_4-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_4
#         spec --color spec/00ImplNotes_Code08_4-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.4-03 -- Indentation:" do
  it "Varying indent steps - OIR:strict - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%div
  %div#id1
     %div#a cblock1
     %div#b
         cblock2
         %p
            cblock3
  %div#id2
      %p cblock4
HAML
      wspc.html.should == <<'HTML'
<div>
  <div id='id1'>
    <div id='a'>cblock1</div>
    <div id='b'>
      cblock2
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
end
#WSE Haml - Variable indent, with oir:strict (no irregular undent)
#Compare with specs: previous Code 8.4-02, and next Code 8.4-04, and
#  the following Code 8.4-05 (oir:loose), and Code 8.4-06
