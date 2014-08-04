require "rdoc2mdoc/constant"
require "rdoc2mdoc/comment"

module Rdoc2mdoc
  class Section
    def initialize(rdoc_section, rdoc_constants, rdoc_attributes)
      @rdoc_section = rdoc_section
      @rdoc_constants = rdoc_constants
      @rdoc_attributes = rdoc_attributes
    end

    def titled?
      !title.nil?
    end

    def title
      rdoc_section.title
    end

    def described?
      !description.nil?
    end

    def description
      comment.mdoc_formatted_content
    end

    def constants
      @constants ||= rdoc_constants.map do |rdoc_constant|
        Constant.new(rdoc_constant)
      end
    end

    private

    attr_reader :rdoc_section, :rdoc_constants

    def markup
      rdoc_section.comments.map(&:normalize).map(&:text).join
    end

    def comment
      @comment ||= Comment.new(markup)
    end
  end
end