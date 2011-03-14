module Beorbcc
  # Module to handle trigraphs. (5.5.1.1) 
  module Trigraph
   
    TRIGRAPHS = { '??=' => '#' , '??)' => ']',  '??!' => '|',
                  '??(' => '[' , "??'" => '^',  '??>' => '}',
                  '??/' => '\\', '??<' => '{',  '??-' => '~' } 

    # Replaces trigraph in the given string.
    # @param [#gsub!] Input in which trgraphs are to be substituted.   
    def replace!(str)
      re = Regexp.union(TRIGRAPHS.keys);
      str.gsub!(re) { |m|  TRIGRAPHS[m.to_s] } 
    end
  
    extend self
  end
end  
  


