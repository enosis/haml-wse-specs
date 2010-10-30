#00ImplNotes_Code09_7-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_7
#         spec --color spec/00ImplNotes_Code09_7-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.7-01 -- Heads:find_and_preserve:" do
  it "FAP - Basic examples" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
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
  Foo\n  <pre>Bar&#x000A;Baz</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz</xre>
</zot>
HTML
  end
end
#Legacy Haml:
#<zot>
#  Foo\n  <pre>Bar&#x000A;Baz</pre>
#  Foo\n  %Bar\n  Baz
#  Foo\n  <xre>Bar\n  Baz</xre>
#</zot>
#In the non-preserving cases (2, 3),
#   those spaces after \n ... should NOT be qty:4 -- 4 would be as if adjusting
#   to align <xre>....</xre> and contents.
#   But each \n segment is actually just text at the same left alignment,
#   as the initial string character, so don't add EXTRA indent
#Note: Because there are no leading or trailing whitespace, the result
#   is the same in WSE Haml
