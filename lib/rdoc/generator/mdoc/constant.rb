require "rdoc/generator/mdoc/comment"

class RDoc::Generator::Mdoc
  class Constant
    def initialize(rdoc_constant)
      @rdoc_constant = rdoc_constant
    end

    def name
      rdoc_constant.name
    end

    def value
      rdoc_constant.value
    end

    def description
      comment.mdoc_formatted_content
    end

    def described?
      !description.empty?
    end

    private

    attr_reader :rdoc_constant

    def comment
      @comment ||= Comment.new(rdoc_constant.comment)
    end
  end
end
