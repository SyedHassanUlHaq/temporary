# temporary

```bash
riscv64-unknown-elf-gcc -march=rv64gcvzvkb_zvbb -mabi=lp64d -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -DENTROPY=0xdeadbeef -DLFSR_BITS=9 -fno-tree-loop-distribute-patterns  -Ienv/riscv-test-env/p -Imacros/general -Tenv/riscv-test-env/p/link.ld crypto_test.S -o crypto_test
```


```bash
spike --isa=rv64gcv_zicntr_zihpm_zvbb --varch=vlen:256,elen:64 --log-commits crypto_test &> crypto_test.log
```