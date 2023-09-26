# frozen_string_literal: true

module JSONSkooma
  module Formatters
    class << self
      attr_accessor :formatters

      def [](name)
        formatters.fetch(name)
      end

      def register(name, formatter)
        formatters[name] = formatter
      end
    end
    self.formatters = {}

    module Flag
      class << self
        def call(result, **_options)
          {"valid" => result.valid?}
        end
      end
    end
    register :flag, Flag

    module Basic
      class << self
        def call(result, **_options)
          valid = result.valid?
          key = valid ? "annotations" : "errors"
          {
            "valid" => valid,
            key => collect_nodes(result, valid)
          }
        end

        private

        def collect_nodes(node, valid, result = [])
          return result if node.valid? != valid

          key = valid ? "annotation" : "error"
          result << node_data(node, key) if node.public_send(key)

          node.children.each do |_, child|
            collect_nodes(child, valid, result)
          end

          result
        end

        def node_data(node, key)
          {
            "instanceLocation" => node.instance.path.to_s,
            "keywordLocation" => node.path.to_s,
            "absoluteKeywordLocation" => node.absolute_uri.to_s,
            key => node.public_send(key)
          }
        end
      end
    end
    register :basic, Basic

    module Detailed
      class << self
        def call(result, **_options)
          valid = result.valid?

          node_data(result, valid, true)
        end

        private

        def node_data(node, valid, first = false)
          data = {
            "valid" => valid,
            "instanceLocation" => node.instance.path.to_s,
            "keywordLocation" => node.path.to_s,
            "absoluteKeywordLocation" => node.absolute_uri.to_s
          }

          child_key = valid ? "annotations" : "errors"
          msg_key = valid ? "annotation" : "error"

          child_data = node.children.filter_map do |_, child|
            node_data(child, valid) if child.valid? == valid
          end

          if first || child_data.length > 1
            data[child_key] = child_data
          elsif child_data.length == 1
            data = child_data[0]
          elsif node.public_send(msg_key)
            data[msg_key] = node.public_send(msg_key)
          end

          data
        end
      end
    end
    register :detailed, Detailed

    module Verbose
      class << self
        def call(result, **_options)
          node_data(result)
        end

        private

        def node_data(node)
          valid = node.valid?
          data = {
            "valid" => valid,
            "instanceLocation" => node.instance.path.to_s,
            "keywordLocation" => node.path.to_s,
            "absoluteKeywordLocation" => node.absolute_uri.to_s
          }
          msg_key = valid ? "annotation" : "error"
          data[msg_key] = node.public_send(msg_key) if node.public_send(msg_key)

          child_key = valid ? "annotations" : "errors"
          child_data = node.children.map do |_, child|
            node_data(child)
          end
          data[child_key] = child_data if child_data.length > 0

          data
        end
      end
    end
    register :verbose, Verbose
  end
end
