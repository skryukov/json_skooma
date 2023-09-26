# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Comment < Base
        self.key = "$comment"
        self.static = true
      end
    end
  end
end
