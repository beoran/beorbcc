module Beorbcc
  class Token
    attr_reader :line
    attr_reader :type
    attr_reader :text
    
    def initialize(type, text, lineno)
      @line    = lineno
      @text    = text
      @type    = type     
    end
  end
end  