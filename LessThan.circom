pragma circom 2.1.0;

// Include the previous component (make sure the file is in the same folder)
// include "Num2Bits.circom"; 

// @title LessThan
// @notice Compares two signals a and b. Returns 1 if a < b, 0 otherwise.
// @param n The bit-width of the inputs.
// @dev Uses the 2^n offset trick to determine signedness in a prime field.
template LessThan(n) {
    signal input a;
    signal input b;
    signal output out;

    // We assume a and b are within [0, 2^n - 1].
    // To check a < b, we calculate: Z = 2^n + a - b.
    // If a < b, then Z < 2^n (n-th bit is 0).
    // If a >= b, then Z >= 2^n (n-th bit is 1).
    signal Z;
    Z <== (1 << n) + a - b;

    // Instantiate Num2Bits with n+1 bits to capture the overflow bit.
    component n2b = Num2Bits(n + 1);
    n2b.in <== Z;

    // The result is the inverse of the (n)-th bit.
    // bit[n] == 0 means a < b (out = 1)
    // bit[n] == 1 means a >= b (out = 0)
    out <== 1 - n2b.bits[n];
}
