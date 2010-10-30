#00ImplNotes_Code09_7-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_7
#         spec --color spec/00ImplNotes_Code09_7-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.7-02 -- Heads:find_and_preserve:" do
  it "FAP - Basic examples - html_escape:true" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
  = find_and_preserve("Foo\n%Bar\nBaz")
  = find_and_preserve("Foo\n<xre>Bar\nBaz</xre>")
HAML
      wspc.html.should == <<"HTML"
<zot>
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
  Foo\n  %Bar\n  Baz
  Foo\n  &lt;xre&gt;Bar\n  Baz&lt;/xre&gt;
</zot>
HTML
    end
  end
end
#Legacy Haml (notice the unexpected transform of \n => &amp;#x000A;:
#<zot>
#  Foo\n  &lt;pre&gt;Bar&amp;#x000A;Baz&lt;/pre&gt;
#  Foo\n  %Bar\n  Baz
#  Foo\n  &lt;xre&gt;Bar\n  Baz&lt;/xre&gt;
#</zot>
