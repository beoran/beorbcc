require 'test_helper'
require 'beorbcc'

def assert_lex(text) 
  lex = Beorbcc::Lexer.new(text)
  res = yield(lex) 
  assert { res } 
end



assert { Beorbcc } 
assert { Beorbcc::Lexer } 
lex = nil 
assert { lex = Beorbcc::Lexer.new("if") }
assert { res = Beorbcc::Lexer.lex("if") }
res = nil
assert_lex('if')  { |l| res = l.lex_keyword() ; res  }
assert 		  { res.type == :keyword } 
assert 		  { res.text == "if"     } 
p res.text
assert_lex('ifa') { |l| !l.lex_keyword() }
assert_lex('if(') { |l| l.lex_keyword()  }
assert_lex('...') { |l| !l.lex_keyword() }
assert_lex('...') { |l| l.lex_punctuator() }
assert_lex('[')   { |l| l.lex_punctuator() }
assert_lex('ifa') { |l| l.lex_identifier() }
assert_lex('9ia') { |l| !l.lex_identifier() }
assert_lex('_ia9$@') { |l| l.lex_identifier() }









