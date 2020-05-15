# frozen_string_literal: true

require "forme/bs4/version"

begin
  require 'forme/bs3'
rescue LoadError => e
  raise "'forme/bs3' not found. Try to add `gem 'forme'` to Gemfile", cause: e
end

module Forme
  register_config(
    :bs4,
    formatter: :bs4,
    inputs_wrapper: :bs4,
    wrapper: :bs4,
    error_handler: :bs4,
    serializer: :bs4,
    labeler: :bs4,
    tag_wrapper: :bs4,
    set_wrapper: :div
  )

  # BS4 Boostrap formatted error handler which adds a span tag
  # with "form-text with-errors" classes for the error message.
  class ErrorHandler::Bootstrap4 < ErrorHandler
    Forme.register_transformer(:error_handler, :bs4, new)

    # Return tag with error message span tag after it.
    def call(tag, input)
      if tag.is_a?(Tag)
        tag.attr[:class] = tag.attr[:class].to_s.gsub(/\s*error\s*/, '')
        tag.attr.delete(:class) if tag.attr[:class].to_s == ''
      end
      attr = input.opts[:error_attr]
      attr = attr ? attr.dup : {}
      Forme.attr_classes(attr, 'form-text with-errors')
      return [tag] if input.opts[:skip_error_message]

      case input.type
      when :submit, :reset
        [tag]
      when :textarea
        input.opts[:wrapper] = :bs4
        if input.opts[:wrapper_attr]
          Forme.attr_classes(input.opts[:wrapper_attr], 'has-error')
        else
          input.opts[:wrapper_attr] = { class: 'has-error' }
        end
        [tag, input.tag(:span, attr, input.opts[:error])]

      when :select
        input.opts[:wrapper] = :bs4
        if input.opts[:wrapper_attr]
          Forme.attr_classes(input.opts[:wrapper_attr], 'has-error')
        else
          input.opts[:wrapper_attr] = { class: 'has-error' }
        end
        [tag, input.tag(:span, attr, input.opts[:error])]

      when :checkbox, :radio

        input.opts[:wrapper] = :div
        if input.opts[:wrapper_attr]
          Forme.attr_classes(input.opts[:wrapper_attr], 'has-error')
        else
          input.opts[:wrapper_attr] = { class: 'has-error' }
        end

        [
          input.tag(:div, { class: input.type.to_s }, [tag]),
          input.tag(:span, attr, input.opts[:error])
        ]
      else
        if input.opts[:wrapper_attr]
          Forme.attr_classes(input.opts[:wrapper_attr], 'has-error')
        else
          input.opts[:wrapper_attr] = { class: 'has-error' }
        end
        [tag, input.tag(:span, attr, input.opts[:error])]
      end
    end
  end

  class Formatter
    class Bs4 < Formatter::Bs3
      Forme.register_transformer(:formatter, :bs4, self)

      def _add_set_error(tags)
        tags << input.tag(
          :span,
          { class: 'form-text with-errors' },
          @opts[:set_error]
        )
      end
    end
  end

  class Formatter
    class Bs4ReadOnly < Formatter::Bs3ReadOnly
      Forme.register_transformer(:formatter, :bs4_readonly, self)
    end
  end

  class InputsWrapper
    class Bootstrap4 < InputsWrapper::Bootstrap3
      Forme.register_transformer(:inputs_wrapper, :bs4, new)
    end
  end

  class InputsWrapper
    class Bs4Table < InputsWrapper::Bs3Table
      Forme.register_transformer(:inputs_wrapper, :bs4_table, new)
    end
  end

  class Labeler
    class Bootstrap4 < Labeler::Bootstrap3
      Forme.register_transformer(:labeler, :bs4, new)
    end
  end

  class Wrapper
    class Bootstrap4 < Wrapper::Bootstrap3
      Forme.register_transformer(:wrapper, :bs4, new)
    end
  end

  class Serializer
    class Bootstrap4 < Serializer
      Forme.register_transformer(:serializer, :bs4, new)

      def call(tag)
        case tag
        when Tag
          case tag.type
          when :input
            # default to <input type="text"...> if not set
            tag.attr[:type] = :text if tag.attr[:type].nil?

            case tag.attr[:type].to_sym
            when :checkbox, :radio, :hidden
              tag.attr[:class]&.gsub!(/\s*form-control\s*/, '')
              tag.attr[:class] = nil if tag.attr[:class]&.empty?
            when :file
              unless tag.attr[:class] && tag.attr[:class].strip != ''
                tag.attr[:class] = nil
              end
            when :submit, :reset
              klass = %w[btn btn-primary]
              if tag.attr[:class] && tag.attr[:class].strip != ''
                klass += tag.attr[:class].split(' ')
              end
              tag.attr[:class] = klass.uniq
              tag.attr[:class] -= ['btn-primary'] unless tag.attr[:class].intersection(
                %w[btn-success btn-info btn-warning btn-danger btn-outline btn-link]
              ).empty?
              tag.attr[:class].join(' ')
            else
              klass = tag.attr[:class] ? "form-control #{tag.attr[:class]}" : ''
              tag.attr[:class] = "form-control #{klass.gsub(/\s*form-control\s*/, '')}".strip
            end

            "<#{tag.type}#{attr_html(tag.attr)}/>"

          when :textarea, :select
            klass = tag.attr[:class] ? "form-control #{tag.attr[:class]}" : ''
            tag.attr[:class] = "form-control #{klass.gsub(/\s*form-control\s*/, '')}".strip
            "#{serialize_open(tag)}#{call(tag.children)}#{serialize_close(tag)}"
          else
            super
          end
        else
          super
        end
      end
    end
  end
end
