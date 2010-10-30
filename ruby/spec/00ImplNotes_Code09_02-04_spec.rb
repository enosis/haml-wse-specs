#00ImplNotes_Code09_2-04_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_2
#         spec --color spec/00ImplNotes_Code09_2-04_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.2-04 -- Heads:HamlComment:" do
  it "Mixed Content - Problematic - WSE Haml" do
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
               -#%sname Spot2
                 %sname Spot3
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
        <sname>Spot3</sname>
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
#WSE Haml: We'd prefer this, where Haml Comment
# is _either_ Inline _or_ Nested,  but WSE Haml can't go that far, probably.
# So instead both of the snames and the sdescr are scooped up into the 
# HamlComment. Solution is similar to what authors must do under 
# Legacy Haml ... see next RSpec.
