# frozen_string_literal: true

module JSONSkooma
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, _abspath)
      if basename.include?("json_")
        super.gsub("Json", "JSON")
      else
        super
      end
    end
  end
end
