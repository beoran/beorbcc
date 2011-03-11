require 'test_helper'
require 'beorbcc'

assert { Beorbcc } 
assert { Beorbcc::Token } 
tok = nil 
assert { tok = Beorbcc::Token.new(:foo, 'foo', 12) }
assert { tok.line == 12  	}
assert { tok.type == :foo  	}
assert { tok.text == 'foo' 	}


