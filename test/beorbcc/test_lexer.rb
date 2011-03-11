require 'test_helper'
require 'beorbcc'

def lex_do(text) 
  lex = Beorbcc::Lexer.new(text)
  return yield(lex)  
end


# Returns true if a Beorbcc lexer cannot lex text using method method 
def lex_no(text, method) 
  lex = Beorbcc::Lexer.new(text)
  res = lex.send(method.to_sym)
  if res
    warn "lex_no got a result: #{res.inspect}"
  end  
  return !res 
end

# helper that displays error messages.
def lex_expect(name, val, want)
  warn "#{name} was #{val.inspect} but #{want.inspect} was expected!"
  return false 
end

# Returns true if a Beorbcc lexer can lex text using method method
# Additionally tests if type and text are correct
def lex_ok(input, method, type = nil, text = nil, line = nil, coln = nil) 
  lex = Beorbcc::Lexer.new(input)
  res = lex.send(method.to_sym)
  if !res  
    warn "Lexer returned nil for #{method}(#{input}) !"; return nil
  end    
  return lex_expect("Type"   , res.type, type)  if type && res.type != type
  return lex_expect("Text"   , res.text, text) if text && res.text != text
  return lex_expect("Line nr", res.line, line) if line && res.line != line
  return lex_expect("Column" , res.coln, coln) if coln && res.coln != coln  
  return res 
end

def lex_type(input, method, type) 
  return lex_ok(input, method, type, nil) 
end



assert { Beorbcc } 
assert { Beorbcc::Lexer } 
lex = nil 
assert { lex = Beorbcc::Lexer.new("if") }
assert { res = Beorbcc::Lexer.lex("if") }
res = nil
assert { lex_ok('if'        , :lex_keyword, :keyword, "if", 1, 3) } 
assert { lex_no('ifa'       , :lex_keyword)                    }
assert { lex_ok('if('       , :lex_keyword , :keyword)         }
assert { lex_no('...'       , :lex_keyword)                    }
assert { lex_ok('...'       , :lex_punctuator, :punctuator)    }
assert { lex_ok('['         , :lex_punctuator)                 }
assert { lex_ok('ifa'       , :lex_identifier)                 }
assert { lex_no('9if'       , :lex_identifier)                 }
assert { lex_ok('_ia9$@'    , :lex_identifier)                 }
assert { lex_no('9$@'       , :lex_decimal_constant)           }
assert { lex_ok('129'       , :lex_decimal_constant)           }
assert { lex_ok('129ul'     , :lex_decimal_constant)           }
assert { lex_ok('129ull'    , :lex_decimal_constant)           }
assert { lex_ok('129ll'     , :lex_decimal_constant)           }
assert { lex_ok('129lu'     , :lex_decimal_constant)           }
assert { lex_no('0129'      , :lex_decimal_constant)           }
assert { lex_no('129.0'     , :lex_decimal_constant)           }
assert { lex_no('129uLf'    , :lex_decimal_constant)           }
assert { lex_ok('0x129uL'   , :lex_hexadecimal_constant)       }
assert { lex_no('129uLf'    , :lex_hexadecimal_constant)       }
assert { lex_no('129uL'     , :lex_octal_constant)             }
assert { lex_no('0x129uL'   , :lex_octal_constant)             }
assert { lex_no('0129'      , :lex_octal_constant)             }
assert { lex_ok('0127'      , :lex_octal_constant)             }
assert { lex_ok('0127'      , :lex_integer_constant, :octal_constant)   }
assert { lex_no('0foo'      , :lex_integer_constant)           }
assert { lex_ok('123'       , :lex_integer_constant, :decimal_constant, '123') }
assert { lex_ok('123llu '   , :lex_integer_constant, :decimal_constant, '123llu') }
assert { lex_ok('.2e-5f'    , :lex_floating_constant, nil, '.2e-5f')          }
# Somewhat more difficult case, the following is .2f - 5, so it parses
assert { lex_ok('.2f-5'     , :lex_floating_constant)                         }
assert { lex_no('.2g-5'     , :lex_floating_constant)                         }
assert { lex_ok('0.2'       , :lex_floating_constant)                         }
assert { lex_ok('0.2e1'     , :lex_floating_constant, nil, '0.2e1')           }
assert { lex_ok('"hello"'   , :lex_string_literal, :string_literal) }
assert { lex_ok("'\u1234'"  , :lex_character_constant, :character_constant) }
assert { lex_ok("'\u1234'"  , :lex_constant, :character_constant) }
assert { lex_ok("1234"      , :lex_constant, :decimal_constant) }
assert { lex_no("'1234'"    , :lex_character_constant) }




=begin
assert_lex('ifa') { |l| l.lex_identifier() }
assert_lex('9ia') { |l| !l.lex_identifier() }
assert_lex('_ia9$@') { |l| l.lex_identifier() }
assert_lex_type('_ia9$@', :identifier, :lex_identifier)
assert_lex_fail('9$@') { |l| l.lex_decimal_constant() }
assert_lex_type('129', :decimal_constant, :lex_decimal_constant)
assert_lex_type('129uL', :decimal_constant, :lex_decimal_constant)
assert_lex_fail('129uLf') { |l| l.lex_decimal_constant() }
=end






