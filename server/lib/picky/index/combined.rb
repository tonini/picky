# encoding: utf-8
#
module Index

  # 
  #
  class Combined < Bundle
    
    delegate :similar,
             :identifier,
             :name,
             :to => :@full
    delegate :type,
             :category,
             :weight,
             :generate_partial_from,
             :generate_caches_from_memory,
             :generate_derived,
             :dump,
             :load,
             :to => :@partial
    
    def initialize full, partial
      @full    = full
      @partial = partial
    end
    
    def ids text
      @full.ids(text) + @partial.ids(text)
    end
    
    def weight text
      [@full.weight(text) || 0, @partial.weight(text) || 0].max
    end
    
  end
  
end