#00ImplNotes_Code09_6-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_6
#         spec --color spec/00ImplNotes_Code09_6-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.6-02 -- Heads:Preserve:" do
  it "Starttag-endtag mechanics, for :preformatted - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code', 'ptag'],
                 :preformatted => ['ver', 'vtag'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "toto\ntutu" )
- html_tabstring('   ')
.wspcpre
  %spqr
    %vtag Dirigo
       Regnat Populus
         Justitia Omnibus
      Esse quam videri
  %snap
    %vtag= "Bar\nBaz"
  %crak
    %vtag #{strvar}
  %pahp
    %vtag
      :preformatted
          def fact(n)  
            (1..n).reduce(1, :*)  
          end  
    %vtag<<ASCII
 o           .'`/
     '      /  (
   O    .-'` ` `'-._      .')
      _/ (o)        '.  .' /
      )       )))     ><  <
      `\  |_\      _.'  '. \
        `-._  _ .-'       `.)
    jgs     `\__\
ASCII
HAML
      wspc.html.should == <<'HTML'
<div class='wspcpre'>
   <spqr>
      <vtag> Dirigo
 Regnat Populus
   Justitia Omnibus
Esse quam videri
      </vtag>
   </spqr>
   <snap>
      <vtag>
Bar
Baz
      </vtag>
   </snap>
   <crak>
      <vtag>
toto
tutu
      </vtag>
   </crak>
   <pahp>
      <vtag>
  def fact(n)  
    (1..n).reduce(1, :*)  
  end  
      </vtag>
   </pahp>
   <vtag>
 o           .'`/
     '      /  (
   O    .-'` ` `'-._      .')
      _/ (o)        '.  .' /
      )       )))     ><  <
      `\  |_\      _.'  '. \
        `-._  _ .-'       `.)
    jgs     `\__\
   </vtag>
</div>
HTML
    end
  end
end
#Notice: WSE filter:preformatted delivers a ContentBlock with the
# offside whitespace removed: whitespace at and to the right of the
# BOD are preserved.
# While, a simple %vtag will produce a ContentBlock aligned
# to indentation 0.
