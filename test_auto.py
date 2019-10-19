from os import *
from random import *

n = 10000
p = 0
t = 0

system('nasm -f elf32 bignum.nasm -o bignum.o && ld -m elf_i386 bignum.o -o bignum')

for r in [2E2, 1E20]:
  for i in range(n):
    a, b = randrange(-r, r), randrange(-r, r)
    m = 0
    t += 1
    try:
      o = popen('echo "%d %d\n" > test && ./bignum < test && rm test' % (a, b)).read().split()
      assert int(o[-2]) == a + b and int(o[-1]) == a * b
      p += 1
    except:
      print(('\rMISS: %d %d' % (a, b)).ljust(50))
    px = int(t / (n * 2) * 30)
    print('\r[' + '=' * px + ' ' * (30 - px) + ']', '\033[1;32m%d\033[0m/\033[1;31m%d\033[0m/%d\t' % (p, t - p, t), end='')

print()