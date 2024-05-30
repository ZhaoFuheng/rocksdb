#!/bin/bash

for i in 0; do
    ./c.sh > "/home/ubuntu/rocksdb/db_bench_results/figure4/c_plot${i}.txt"
    ./T.sh > "/home/ubuntu/rocksdb/db_bench_results/figure4/T_plot${i}.txt"
done
