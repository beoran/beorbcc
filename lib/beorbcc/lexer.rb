require 'strscan'

module Beorbcc
  # Lexer class for C.
  # According to the standard A.1.1
  class Lexer    
    def initialize(text)
      lex_init(text)
    end
    
    def scan(pattern)
      @last = @scanner.scan(pattern)
      return @last
    end
    
    def token(type, text = nil, line = nil)
      text ||= @last
      line ||= @line      
      return Token.new(type, text, line)
    end
    
    KEYWORDS = %w{auto break case char const continue default do double else
		  enum extern float for goto if inline int long register
		  restrict return short signed sizeof static struct switch
		  typedef union unsigned void volatile while _Bool _Complex
		  _Imaginary}
    
    def lex_keyword
      for word in KEYWORDS do
	re = /#{word}(?![a-zA-Z0-9_])/
	ok = self.scan(re)
	return token(:keyword) if ok
      end
      return nil
    end
    
    PUNCTUATORS = %w{[ ] ( ) { } . -> ++ -- & * + - ~ ! / % << >> < > <= >= 
		     ? : ; ... = *= /= %= += -= <<= , # ## <: :> <% %> %: %:%: 
		     == >>= != &= ^ | ^= && || |=}
    def lex_punctuator
      for punc in PUNCTUATORS do
        re = Regexp.new("\\" + punc.split('').join("\\"))	
	ok = self.scan(Regexp.new(re))
	return token(:punctuator) if ok
      end
      return nil
    end
    
    def lex_identifier
      ok = self.scan(/[A-Za-z$@_][A-Za-z0-9$@_]+/)
      return token(:identifier) if ok
      return nil
    end  
    
		     
    def lex_token
      return lex_keyword || lex_identifier     || 
	    lex_constant || lex_string_literal || lex_punctuator	    
    end
    
    def lex_preprocessing_token
      return lex_header_name || lex_identifier      || 
	    lex_pp_number || lex_character_constant || 
	    lex_string_literal || lex_punctuator    || lex_non_whitespace	    
    end
    
    def lex_init(text)
      @lineno  = 0
      @tokens  = []
      @scanner = nil 
      @last    = nil
      @scanner = StringScanner.new(text)
    end
    
    def lex()
      lex_token
      return @tokens
    end 
    
    def self.lex(text)
      lexer = self.new(text)
      return lexer.lex
    end
  end
end  


=begin
A.1 Lexical grammar
A.1.1 Lexical elements
(6.4) token:
keyword
identifier
constant
string-literal
punctuator
(6.4) preprocessing-token:
header-name
identifier
pp-number
character-constant
string-literal
punctuator
each non-white-space character that cannot be one of the above
A.1.2 Keywords
(6.4.1) keyword: one of
auto
break
case
char
const
continue
default
do
double
else
§A.1.2
enum
extern
float
for
goto
if
inline
int
long
register
restrict
return
short
signed
sizeof
static
struct
switch
typedef
union
Language syntax summary
unsigned
void
volatile
while
_Bool
_Complex
_Imaginary
403
ISO/IEC 9899:TC3
Committee Draft — Septermber 7, 2007
WG14/N1256
A.1.3 Identifiers
(6.4.2.1) identifier:
identifier-nondigit
identifier identifier-nondigit
identifier digit
(6.4.2.1) identifier-nondigit:
nondigit
universal-character-name
other implementation-defined characters
(6.4.2.1) nondigit: one of c d e f g h i
_ a b p q r s t u v
n o C D E F G H I
A B P Q R S T U V
N O 
(6.4.2.1) digit: one of 3 4 5 6 7 8 9
0 1 2 
j
w
J
W
k
x
K
X
l
y
L
Y
m
z
M
Z
A.1.4 Universal character names
(6.4.3) universal-character-name:
\u hex-quad
\U hex-quad hex-quad
(6.4.3) hex-quad:
hexadecimal-digit hexadecimal-digit
hexadecimal-digit hexadecimal-digit
A.1.5 Constants
(6.4.4) constant:
integer-constant
floating-constant
enumeration-constant
character-constant
(6.4.4.1) integer-constant:
decimal-constant integer-suffixopt
octal-constant integer-suffixopt
hexadecimal-constant integer-suffixopt
(6.4.4.1) decimal-constant:
nonzero-digit
decimal-constant digit
404
Language syntax summary
§A.1.5
WG14/N1256
Committee Draft — Septermber 7, 2007
ISO/IEC 9899:TC3
(6.4.4.1) octal-constant:
0
octal-constant octal-digit
(6.4.4.1) hexadecimal-constant:
hexadecimal-prefix hexadecimal-digit
hexadecimal-constant hexadecimal-digit
(6.4.4.1) hexadecimal-prefix: one of
0x 0X
(6.4.4.1) nonzero-digit: one of 6 7 8
1 2 3 4 5 
(6.4.4.1) octal-digit: one of 5 6 7
0 1 2 3 
6 7
4
(6.4.4.1) hexadecimal-digit: one of
0 1 2 3 4 5
a b c d e f
A B C D E F
9
8
9
(6.4.4.1) integer-suffix:
unsigned-suffix long-suffixopt
unsigned-suffix long-long-suffix
long-suffix unsigned-suffixopt
long-long-suffix unsigned-suffixopt
(6.4.4.1) unsigned-suffix: one of
u U
(6.4.4.1) long-suffix: one of
l L
(6.4.4.1) long-long-suffix: one of
ll LL
(6.4.4.2) floating-constant:
decimal-floating-constant
hexadecimal-floating-constant
(6.4.4.2) decimal-floating-constant:
fractional-constant exponent-partopt floating-suffixopt
digit-sequence exponent-part floating-suffixopt
§A.1.5
Language syntax summary
405
ISO/IEC 9899:TC3
Committee Draft — Septermber 7, 2007
WG14/N1256
(6.4.4.2) hexadecimal-floating-constant:
hexadecimal-prefix hexadecimal-fractional-constant
binary-exponent-part floating-suffixopt
hexadecimal-prefix hexadecimal-digit-sequence
binary-exponent-part floating-suffixopt
(6.4.4.2) fractional-constant:
digit-sequenceopt . digit-sequence
digit-sequence .
(6.4.4.2) exponent-part:
e signopt digit-sequence
E signopt digit-sequence
(6.4.4.2) sign: one of
+ -
(6.4.4.2) digit-sequence:
digit
digit-sequence digit
(6.4.4.2) hexadecimal-fractional-constant:
hexadecimal-digit-sequenceopt .
hexadecimal-digit-sequence
hexadecimal-digit-sequence .
(6.4.4.2) binary-exponent-part:
p signopt digit-sequence
P signopt digit-sequence
(6.4.4.2) hexadecimal-digit-sequence:
hexadecimal-digit
hexadecimal-digit-sequence hexadecimal-digit
(6.4.4.2) floating-suffix: one of
f l F L
(6.4.4.3) enumeration-constant:
identifier
(6.4.4.4) character-constant:
' c-char-sequence '
L' c-char-sequence '
406
Language syntax summary
§A.1.5
WG14/N1256
Committee Draft — Septermber 7, 2007
ISO/IEC 9899:TC3
(6.4.4.4) c-char-sequence:
c-char
c-char-sequence c-char
(6.4.4.4) c-char:
any member of the source character set except
the single-quote ', backslash \, or new-line character
escape-sequence
(6.4.4.4) escape-sequence:
simple-escape-sequence
octal-escape-sequence
hexadecimal-escape-sequence
universal-character-name
(6.4.4.4) simple-escape-sequence: one of
\' \" \? \\
\a \b \f \n \r \t
\v
(6.4.4.4) octal-escape-sequence:
\ octal-digit
\ octal-digit octal-digit
\ octal-digit octal-digit octal-digit
(6.4.4.4) hexadecimal-escape-sequence:
\x hexadecimal-digit
hexadecimal-escape-sequence hexadecimal-digit
A.1.6 String literals
(6.4.5) string-literal:
" s-char-sequenceopt "
L" s-char-sequenceopt "
(6.4.5) s-char-sequence:
s-char
s-char-sequence s-char
(6.4.5) s-char:
any member of the source character set except
the double-quote ", backslash \, or new-line character
escape-sequence
§A.1.6
Language syntax summary
407
ISO/IEC 9899:TC3
Committee Draft — Septermber 7, 2007
WG14/N1256
A.1.7 Punctuators
(6.4.6) punctuator: one of
[ ] ( ) { } . ->
++ -- & * + - ~ !
/ % << >> < > <= >=
? : ; ...
= *= /= %= += -= <<=
, # ##
<: :> <% %> %: %:%:
==
>>=
!=
&=
^
|
^=
&&
||
|=
A.1.8 Header names
(6.4.7) header-name:
< h-char-sequence >
" q-char-sequence "
(6.4.7) h-char-sequence:
h-char
h-char-sequence h-char
(6.4.7) h-char:
any member of the source character set except
the new-line character and >
(6.4.7) q-char-sequence:
q-char
q-char-sequence q-char
(6.4.7) q-char:
any member of the source character set except
the new-line character and "
A.1.9 Preprocessing numbers
(6.4.8) pp-number:
digit
. digit
pp-number
pp-number
pp-number
pp-number
pp-number
pp-number
pp-number
408
digit
identifier-nondigit
e sign
E sign
p sign
P sign
.
Language syntax sum
=end