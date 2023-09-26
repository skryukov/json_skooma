# frozen_string_literal: true

module JSONSkooma
  class Inflector < Zeitwerk::Inflector
    def camelize(basename, _abspath)
      if basename.include?("json_")
        super.gsub("Json", "JSON")
      else
        super
      end
    end
  end
end
