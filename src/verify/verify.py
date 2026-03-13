import numpy as np

# ================================================
# Hardware-Software Co-Verification Script
# Verifies Verilog systolic array output against
# NumPy golden reference model
# ================================================

# Matrix A — same as testbench
A = np.array([
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 1, 2],
    [3, 4, 3, 4]
], dtype=np.int32)

# Matrix B — Identity matrix
B = np.eye(4, dtype=np.int32)

# Golden reference — NumPy matrix multiplication
golden = np.dot(A, B)

# Verilog output — from EDA Playground simulation
verilog_output = np.array([
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 1, 2],
    [3, 4, 3, 4]
], dtype=np.int32)

print("Matrix A:")
print(A)
print("\nMatrix B (Identity):")
print(B)
print("\nGolden Reference (NumPy):")
print(golden)
print("\nVerilog Output:")
print(verilog_output)

# Verify
if np.array_equal(golden, verilog_output):
    print("\n✅ VERIFICATION PASSED — Verilog matches NumPy exactly")
else:
    diff = golden - verilog_output
    print("\n❌ VERIFICATION FAILED")
    print("Difference:")
    print(diff)

# Additional test — random matrix
print("\n--- Random Matrix Test ---")
np.random.seed(42)
A_rand = np.random.randint(0, 16, (4,4), dtype=np.int32)
B_rand = np.random.randint(0, 16, (4,4), dtype=np.int32)
result = np.dot(A_rand, B_rand)
print("A:")
print(A_rand)
print("B:")
print(B_rand)
print("A x B (reference for future Verilog test):")
print(result)
