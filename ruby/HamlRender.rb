# HamlRender.rb

require "haml"

class HamlRender
  @html_result
  def render_haml(hamlstr, opts = { :html_escape => false, :preserve => ['pre', 'textarea', 'code']}, locs = {} )
    h_eng = Haml::Engine.new(hamlstr, opts)
    @html_result = h_eng.render(h_eng, locs)
  end
  def html
    return @html_result
  end
end
