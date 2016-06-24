# Rubik-s-Cube
Align the 2*2 Rubik's cube

# How to start 
```bash
# compile
iverilog *.v
# -> a.out

# execute 
vvp ./a.out
# -> make dump file, which is named 'top_test.vcd' 

# simulate
gtkwave top_test.vcd
```
