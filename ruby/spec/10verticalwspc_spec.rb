#10verticalwspc_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/10verticalwspc_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines


#================================================================
describe HamlRender, "-01- Vertical Whitespace" do
  it "Single whiteline Removal" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1

%p para2

%p para3
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>para2</p>
<p>para3</p>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-02- Vertical Whitespace" do
  it "Single whiteline Removal" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit 
  apples
  oranges

%vege
  cucumbers
HAML
      wspc.html.should == <<HTML
<fruit>
  apples
  oranges
</fruit>
<vege>
  cucumbers
</vege>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-03- Vertical Whitespace" do
  it "Multiple trailing/leading (exterior) whiteline Consolidation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%starch potatoes


%fruit 
  apples
  oranges



%vege
  cucumbers
HAML
      wspc.html.should == <<HTML
<starch>potatoes</starch>

<fruit>
  apples
  oranges
</fruit>

<vege>
  cucumbers
</vege>
HTML
    end
  end
end
#  1 whiteline  : Consolidates to 0
#n>1 whitelines : Consolidates to 1


#================================================================
describe HamlRender, "-04- Vertical Whitespace" do
  it "Multiple interior whiteline Consolidation" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit 
  apples


  oranges

%vege
  cucumbers
HAML
      wspc.html.should == <<HTML
<fruit>
  apples

  oranges
</fruit>
<vege>
  cucumbers
</vege>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-05- Vertical Whitespace" do
  it "Multiple interior whiteline Consolidation - Whitespace Removal Inside <" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit<
  apples


  oranges

%vege
  cucumbers
HAML
      wspc.html.should == <<HTML
<fruit>apples
oranges</fruit>
<vege>
  cucumbers
</vege>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-06- Vertical Whitespace" do
  it "Multiple interior whiteline Consolidate - Whitespace Removal Outside >" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%fruit
  apples


  oranges


%vege>
  cucumbers
HAML
      wspc.html.should == <<HTML
<fruit>
  apples

  oranges

</fruit><vege>
  cucumbers
</vege>
HTML
    end
  end
end
#Legacy Bug/nit: trim_out on last Element results in
#  removal of fragment/file-ending newline
