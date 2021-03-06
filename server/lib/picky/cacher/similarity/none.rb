module Cacher

  module Similarity

    # Similarity strategy that does nothing.
    #
    class None < Strategy

      # Does not encode text. Just returns nil.
      #
      def encoded text
        nil
      end

      # Returns an empty index.
      #
      def generate_from index
        {}
      end

    end

  end

end