# frozen_string_literal: true

module JSONSkooma
  class Vocabulary
    attr_reader :kw_classes, :uri

    def initialize(uri, *keywords)
      @kw_classes = keywords.map { |keyword| [keyword.key, keyword] }.to_h
      @uri = uri
    end
  end
end
