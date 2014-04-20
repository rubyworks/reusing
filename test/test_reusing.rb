require 'reusing'

$LOAD_PATH.unshift(__dir__)

using 'example'

module M
  refine String do
    def important
      self + "!"
    end
  end
end

using M

result = "this".example
raise unless result == "this example"

result = "this".important
raise unless result == "this!"


