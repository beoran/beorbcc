require 'test_helper'
require 'beorbcc'
require 'beorbcc/trigraph'


assert { Beorbcc::Trigraph }
# Examples as per 5.2.1.1
t1 = '??=define arraycheck(a, b) a??(b??) ??!??! b??(a??)' 
r1 = '#define arraycheck(a, b) a[b] || b[a]'
t2 = 'printf("Eh???/n");'
r2 = 'printf("Eh?\\n");'

assert { Beorbcc::Trigraph.replace!(t1) == r1 }
assert { t1 == r1 }  
assert { Beorbcc::Trigraph.replace!(t2) == r2 }
assert { t2 == r2 }  
 




