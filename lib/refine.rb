require 'finder'

def refinement(feature)
  file = Find.feature(feature, :absolute=>true).first

  raise LoadError unless file

  text = File.read(file)

  text = text.gsub(/^\s*class\s*([A-Z]\w*)\s*$/, 'module Refinements; refine \1 do')

  text = text + "\nend"

  eval text, TOPLEVEL_BINDING

  return Refinements
end

