module Beorbcc
  class Token
    attr_reader :line
    attr_reader :type
    attr_reader :text
    attr_reader :coln
    
    def initialize(type, text, lineno = 1, coln = 1)
      @line    = lineno
      @text    = text
      @type    = type     
      @coln    = coln
    end
  end
end  