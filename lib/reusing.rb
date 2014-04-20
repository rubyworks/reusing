require 'finder'

class << self
  alias :reusing :using

  define_method :using do |feature|
    if String === feature
      file = Find.feature(feature, :absolute=>true).first

      raise LoadError, "LoadError: cannot load such file -- #{file}" unless file

      text = File.read(file)

      # text = text.gsub(/^\s*class\s*([A-Z]\w*)\s*$/, 'module Refinements; refine \1 do')

      text = text.gsub(/^\s*class\s*([A-Z]\w*)\s*$/, 'refine \1 do')
      text = "m = Module.new do\n" + text + "\nend\nreusing m\n"

      eval(text, TOPLEVEL_BINDING)
    else
      text = "reusing #{feature}"

      eval(text, TOPLEVEL_BINDING)
    end
  end
end

