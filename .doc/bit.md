<div id="site">

[Bit<span id="logo">Op</span>](http://bitop.luajit.org)

</div>

<div id="head">

# API Functions

</div>

<div id="nav">

- [Lua BitOp](index.html)
- [Installation](install.html)
- <a href="api.html" class="current">API Functions</a>
- [Semantics](semantics.html)
- [Changes](changes.html)
- [Download
  <span class="ext">»</span>](http://bitop.luajit.org/download.html)

</div>

<div id="main">

This list of API functions is not intended to replace a tutorial. If you
are not familiar with the terms used, you may want to study the
[<span class="ext">»</span> Wikipedia article on bitwise
operations](http://en.wikipedia.org/wiki/Bitwise_operation) first.

## Loading the BitOp Module

The suggested way to use the BitOp module is to add the following to the
start of *every* Lua file that needs one of its functions:

```lua
local bit = require("bit")
```

This makes the dependency explicit, limits the scope to the current file
and provides faster access to the `bit.*` functions, too. It's good
programming practice *not* to rely on the global variable `bit` being
set (assuming some other part of your application has already loaded the
module). The `require` function ensures the module is only loaded once,
in any case.

## Defining Shortcuts

It's a common (but not a required) practice to cache often used module
functions in locals. This serves as a shortcut to save some typing and
also speeds up resolving them (only relevant if called hundreds of
thousands of times).

```lua
local bnot = bit.bnot
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local lshift, rshift, rol = bit.lshift, bit.rshift, bit.rol
-- etc...

-- Example use of the shortcuts:
local function tr_i(a, b, c, d, x, s)
  return rol(bxor(c, bor(b, bnot(d))) + a + x, s) + b
end
```

Remember that **`and`**, **`or`** and **`not`** are reserved keywords in
Lua. They cannot be used for variable names or literal field names.
That's why the corresponding bitwise functions have been named `band`,
`bor`, and `bnot` (and `bxor` for consistency).

While we are at it: a common pitfall is to use `bit` as the name of a
local temporary variable — well, don't! :-)

## About the Examples

The examples below show small Lua one-liners. Their expected output is
shown after `-->`. This is interpreted as a comment marker by Lua so you
can cut & paste the whole line to a Lua prompt and experiment with it.

Note that all bit operations return *signed* 32 bit numbers
([rationale](semantics.html#range)). And these print as signed decimal
numbers by default.

For clarity the examples assume the definition of a helper function
`printx()`. This prints its argument as an *unsigned* 32 bit hexadecimal
number on all platforms:

```lua
function printx(x)
  print("0x"..bit.tohex(x))
end
```

## Bit Operations

### `y = bit.tobit(x)`

Normalizes a number to the numeric range for bit operations and returns
it. This function is usually not needed since all bit operations already
normalize all of their input arguments. Check the [operational
semantics](semantics.html) for details.

```lua
print(0xffffffff)                --> 4294967295 (*)
print(bit.tobit(0xffffffff))     --> -1
printx(bit.tobit(0xffffffff))    --> 0xffffffff
print(bit.tobit(0xffffffff + 1)) --> 0
print(bit.tobit(2^40 + 1234))    --> 1234
```

(\*) See the treatment of [hex literals](semantics.html#hexlit) for an
explanation why the printed numbers in the first two lines differ (if
your Lua installation uses a `double` number type).

### `y = bit.tohex(x [,n])`

Converts its first argument to a hex string. The number of hex digits is
given by the absolute value of the optional second argument. Positive
numbers between 1 and 8 generate lowercase hex digits. Negative numbers
generate uppercase hex digits. Only the least-significant 4\*|n| bits
are used. The default is to generate 8 lowercase hex digits.

```lua
print(bit.tohex(1))              --> 00000001
print(bit.tohex(-1))             --> ffffffff
print(bit.tohex(0xffffffff))     --> ffffffff
print(bit.tohex(-1, -8))         --> FFFFFFFF
print(bit.tohex(0x21, 4))        --> 0021
print(bit.tohex(0x87654321, 4))  --> 4321
```

### `y = bit.bnot(x)`

Returns the bitwise **not** of its argument.

```lua
print(bit.bnot(0))            --> -1
printx(bit.bnot(0))           --> 0xffffffff
print(bit.bnot(-1))           --> 0
print(bit.bnot(0xffffffff))   --> 0
printx(bit.bnot(0x12345678))  --> 0xedcba987
```

### `y = bit.bor(x1 [,x2...])` `y = bit.band(x1 [,x2...])` `y = bit.bxor(x1 [,x2...])`

Returns either the bitwise **or**, bitwise **and**, or bitwise **xor**
of all of its arguments. Note that more than two arguments are allowed.

```lua
print(bit.bor(1, 2, 4, 8))                --> 15
printx(bit.band(0x12345678, 0xff))        --> 0x00000078
printx(bit.bxor(0xa5a5f0f0, 0xaa55ff00))  --> 0x0ff00ff0
```

### `y = bit.lshift(x, n)` `y = bit.rshift(x, n)` `y = bit.arshift(x, n)`

Returns either the bitwise **logical left-shift**, bitwise **logical
right-shift**, or bitwise **arithmetic right-shift** of its first
argument by the number of bits given by the second argument.

Logical shifts treat the first argument as an unsigned number and shift
in 0-bits. Arithmetic right-shift treats the most-significant bit as a
sign bit and replicates it.<br>
Only the lower 5 bits of the shift count are used (reduces to the range
\[0..31\]).

```lua
print(bit.lshift(1, 0))              --> 1
print(bit.lshift(1, 8))              --> 256
print(bit.lshift(1, 40))             --> 256
print(bit.rshift(256, 8))            --> 1
print(bit.rshift(-256, 8))           --> 16777215
print(bit.arshift(256, 8))           --> 1
print(bit.arshift(-256, 8))          --> -1
printx(bit.lshift(0x87654321, 12))   --> 0x54321000
printx(bit.rshift(0x87654321, 12))   --> 0x00087654
printx(bit.arshift(0x87654321, 12))  --> 0xfff87654
```

### `y = bit.rol(x, n)` `y = bit.ror(x, n)`

Returns either the bitwise **left rotation**, or bitwise **right
rotation** of its first argument by the number of bits given by the
second argument. Bits shifted out on one side are shifted back in on the
other side.<br>
Only the lower 5 bits of the rotate count are used (reduces to the range
\[0..31\]).

```lua
printx(bit.rol(0x12345678, 12))   --> 0x45678123
printx(bit.ror(0x12345678, 12))   --> 0x67812345
```

### `y = bit.bswap(x)`

Swaps the bytes of its argument and returns it. This can be used to
convert little-endian 32 bit numbers to big-endian 32 bit numbers or
vice versa.

```lua
printx(bit.bswap(0x12345678)) --> 0x78563412
printx(bit.bswap(0x78563412)) --> 0x12345678
```

## Example Program

This is an implementation of the (naïve) *Sieve of Eratosthenes*
algorithm. It counts the number of primes up to some maximum number.

A Lua table is used to hold a bit-vector. Every array index has 32 bits
of the vector. Bitwise operations are used to access and modify them.
Note that the shift counts don't need to be masked since this is already
done by the BitOp shift and rotate functions.

```lua
local bit = require("bit")
local band, bxor = bit.band, bit.bxor
local rshift, rol = bit.rshift, bit.rol

local m = tonumber(arg and arg[1]) or 100000
if m < 2 then m = 2 end
local count = 0
local p = {}

for i=0,(m+31)/32 do p[i] = -1 end

for i=2,m do
  if band(rshift(p[rshift(i, 5)], i), 1) ~= 0 then
    count = count + 1
    for j=i+i,m,i do
      local jx = rshift(j, 5)
      p[jx] = band(p[jx], rol(-2, j))
    end
  end
end

io.write(string.format("Found %d primes up to %d\n", count, m))
```

Lua BitOp is quite fast. This program runs in less than 90 milliseconds
on a 3 GHz CPU with a standard Lua installation, but performs more than
a million calls to bitwise functions. If you're looking for even more
speed, check out
[<span class="ext">»</span> LuaJIT](http://luajit.org).

## Caveats

### Signed Results

Returning signed numbers from bitwise operations may be surprising to
programmers coming from other programming languages which have both
signed and unsigned types. But as long as you treat the results of
bitwise operations uniformly everywhere, this shouldn't cause any
problems.

Preferably format results with `bit.tohex` if you want a reliable
unsigned string representation. Avoid the `"%x"` or `"%u"` formats for
`string.format`. They fail on some architectures for negative numbers
and can return more than 8 hex digits on others.

You may also want to avoid the default number to string coercion, since
this is a signed conversion. The coercion is used for string
concatenation and all standard library functions which accept string
arguments (such as `print()` or `io.write()`).

### Conditionals

If you're transcribing some code from C/C++, watch out for bit
operations in conditionals. In C/C++ any non-zero value is implicitly
considered as "true". E.g. this C code:<br>
`  if (x & 3) ...`<br>
must not be turned into this Lua code:<br>
`  if band(x, 3) then ... -- `*`wrong!`*

In Lua all objects except `nil` and `false` are considered "true". This
includes all numbers. An explicit comparison against zero is required in
this case:<br>
`  if band(x, 3) ~= 0 then ... -- `*`correct!`*

### Comparing Against Hex Literals

Comparing the results of bitwise operations (*signed* numbers) against
hex literals (*unsigned* numbers) needs some additional care. The
following conditional expression may or may not work right, depending on
the platform you run it on:<br>
`  bit.bor(x, 1) == 0xffffffff`<br>
E.g. it's never true on a Lua installation with the default number type.
Some simple solutions:

- Either never use hex literals larger than 0x7fffffff in comparisons:<br>
  `  bit.bor(x, 1) == -1`
- Or convert them with `bit.tobit()` before comparing:<br>
  `  bit.bor(x, 1) == bit.tobit(0xffffffff)`
- Or use a generic workaround with `bit.bxor()`:<br>
  `  bit.bxor(bit.bor(x, 1), 0xffffffff) == 0`
- Or use a case-specific workaround:<br>
  `  bit.rshift(x, 1) == 0x7fffffff`

<br>

</div>

<div id="foot">

------------------------------------------------------------------------

Copyright © 2012 Mike Pall <span class="noprint"> ·
[Contact](contact.html) </span>

</div>
