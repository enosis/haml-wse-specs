#00ImplNotes_Code08_9-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_9
#         spec --color spec/00ImplNotes_Code08_9-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.9-01 -- Whitelines:" do
  it "Whiteline Consolidation- WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.quux
    %div
      %p cblock1
      %p

         cblock2a      

      
         cblock2b      

         cblock2c


      %p cblock3

      %p cblock4inline
         cblock4a
          -#             # Inserted into Nested Content -- a Haml Comment
           cblock4c      # Captured by Haml Comment as Nested Content ContentBlock

           cblock4d
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <div>
    <p>cblock1</p>
    <p>
      cblock2a

      cblock2b
      cblock2c
    </p>

    <p>cblock3</p>

    <p>
      cblock4inline
      cblock4a
      cblock4d
    </p>
  </div>
</div>
HTML
    end
  end
end
