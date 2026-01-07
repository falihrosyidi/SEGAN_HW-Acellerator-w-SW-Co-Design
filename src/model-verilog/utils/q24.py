#!/usr/bin/env python3
import sys
# Divisor for Q24 (2^24)
SCALE = 16777216.0

for line in sys.stdin:
    try:
        # GTKWave sends hex strings
        val = int(line.strip(), 16)
        # Handle 32-bit signed conversion
        if val > 0x7FFFFFFF: val -= 0x100000000
        print(f"{val/SCALE:.5f}")
    except:
        print("NaN")