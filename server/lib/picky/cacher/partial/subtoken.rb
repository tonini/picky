module Cacher

  module Partial
    
    # Generates the right subtokens for use in the subtoken strategy.
    #
    class SubstringGenerator
      
      attr_reader :from, :to
      
      def initialize from, to
        @from, @to = from, to
        
        if @to.zero?
          def each_subtoken token, &block
            token.each_subtoken @from, &block
          end
        else
          def each_subtoken token, &block
            token[0..@to].intern.each_subtoken @from, &block
          end
        end
        
      end
      
    end
    
    # The subtoken partial strategy.
    #
    # If given
    # "florian"
    # will index
    # "floria"
    # "flori"
    # "flor"
    # "flo"
    # "fl"
    # "f"
    # Depending on what the given from value is. (Example with from == 1)
    #
    class Substring < Strategy
      
      # Down to is how far it will go down in generating the subtokens.
      #
      # Examples:
      # With :hello, and to -1
      # * down to == 1: [:hello, :hell, :hel, :he, :h]
      # * down to == 4: [:hello, :hell]
      #
      # With :hello, and to -2
      # * down to == 1: [:hell, :hel, :he, :h]
      # * down to == 4: [:hell]
      #
      def initialize options = {}
        from     = options[:from] || 1
        to = options[:to] || -1
        @generator = SubstringGenerator.new from, to
      end
      def from
        @generator.from
      end
      def to
        @generator.to
      end
      
      # Generates a partial index from the given index.
      #
      def generate_from index
        result = {}
        
        # Generate for each key token the subtokens.
        #
        i = 0
        index.each_key do |token|
          i += 1
          if i == 5000
            timed_exclaim "Generating partial tokens for token #{token}. This appears every 5000 tokens."
            i = 0
          end
          generate_for token, index, result
        end
        
        # Remove duplicate ids.
        #
        # TODO If it is unique for a subtoken, it is
        #      unique for all derived longer tokens.
        #
        result.each_value &:uniq!
        
        result
      end
      
      private
        
        # To each shortened token of :test
        # :test, :tes, :te, :t
        # add all ids of :test
        #
        # "token" here means just text.
        #
        # TODO Could be improved by appending the aforegoing ids?
        #
        def generate_for token, index, result
          @generator.each_subtoken(token) do |subtoken|
            if result[subtoken]
              result[subtoken] += index[token] # unique
            else
              result[subtoken] = index[token].dup # TODO Spec this dup
            end
          end
        end
        
    end
    
  end
  
end