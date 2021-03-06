require "rdoc/generator/mdoc/helpers"

class RDoc::Generator::Mdoc
  class RenderContext
    include Helpers

    def initialize(assigns)
      assigns.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def binding
      super
    end
  end
end
