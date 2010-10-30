#00ImplNotes_Code09_2-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_2
#         spec --color spec/00ImplNotes_Code09_2-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.2-03 -- Heads:HamlComment:" do
  it "Setup variable indent - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.tutu
    %esku
      %skulist
        %scat Lights
                   %sid 20301
                 %sname Spot2
                %sdescr Follow spotlight
        %scat Sound
                   %sid 20304
                 %sname Amplifier
                %sdescr 60watt reverb
HAML
      wspc.html.should == <<'HTML'
<div class='tutu'>
  <esku>
    <skulist>
      <scat>Lights
        <sid>20301</sid>
        <sname>Spot2</sname>
        <sdescr>Follow spotlight</sdescr>
      <scat>Sound
        <sid>20304</sid>
        <sname>Amplifier</sname>
        <sdescr>60watt reverb</sdescr>
      </scat>
    </skulist>
  </esku>
</div>
HTML
    end
  end
end
