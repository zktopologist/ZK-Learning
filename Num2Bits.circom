pragma circom 2.1.0;

// @title Num2Bits
// @notice Decomposes a field element into its binary representation (n bits).
// @param n The number of bits for the decomposition.
// @dev Critical for range checks and inequality logic in finite fields.
template Num2Bits(n) {
    signal input in;
    signal output bits[n];
    var sum = 0;

    for (var i = 0; i < n; i++) {
        // Step 1: Calculate the value of each bit (Witness generation)
        bits[i] <-- (in >> i) & 1;

        // Step 2: Boolean constraint.
        // Every bit must be either 0 or 1. Mathematically: x^2 - x = 0.
        // This is crucial for soundness!
        bits[i] * (1 - bits[i]) === 0;

        // Step 3: Accumulate the weighted sum for the final integrity check.
        sum += bits[i] * (2 ** i);
    }

    // Step 4: Final integrity constraint.
    // Proves that the bit decomposition actually sums up to the original input.
    // This prevents field overflow attacks where 'in' could be > 2^n.
    in === sum;
}
