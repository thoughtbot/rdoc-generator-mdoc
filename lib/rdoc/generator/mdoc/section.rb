require "rdoc/generator/mdoc/constant"
require "rdoc/generator/mdoc/comment"
require "rdoc/generator/mdoc/attribute"
require "rdoc/generator/mdoc/method"

class RDoc::Generator::Mdoc
  class Section
    def self.method_types
      [:class, :instance]
    end

    def initialize(
      rdoc_section,
      rdoc_constants,
      rdoc_attributes,
      mandb_section,
      parent
    )
      @rdoc_section = rdoc_section
      @rdoc_constants = rdoc_constants
      @rdoc_attributes = rdoc_attributes
      @mandb_section = mandb_section
      @parent = parent
    end

    def titled?
      !title.nil?
    end

    def title
      rdoc_section.title
    end

    def described?
      !description.empty?
    end

    def description
      comment.mdoc_formatted_content
    end

    def constants
      @constants ||= rdoc_constants.map do |rdoc_constant|
        Constant.new(rdoc_constant)
      end
    end

    def attributes
      @attributes ||= rdoc_attributes.map do |rdoc_attribute|
        Attribute.new(rdoc_attribute)
      end
    end

    def methods
      self.class.method_types.flat_map { |type| methods_of_type(type) }
    end

    def methods_of_type(type)
      @methods_of_type ||= {}
      @methods_of_type[type] ||=
        parent.
        methods_by_type(rdoc_section)[type.to_s].
        flat_map do |visibility, rdoc_methods|
          rdoc_methods.select do |rdoc_method|
            rdoc_method.is_a? RDoc::AnyMethod
          end.map do |rdoc_method|
            Method.new(rdoc_method, mandb_section, visibility)
          end
        end
    end

    private

    attr_reader :rdoc_section, :rdoc_constants, :rdoc_attributes,
      :mandb_section, :parent

    def comment
      @comment ||= if rdoc_section.comments.is_a? RDoc::Markup::Document
        Comment.new(rdoc_section.comments)
      else
        Comment.new(rdoc_section.comments.map(&:normalize).map(&:text).join)
      end
    end
  end
end
