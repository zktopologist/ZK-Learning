pragma circom 2.1.0;

// @title IsZero
// @notice Checks if the input signal is zero.
// @dev A classic example of ZK logic: mapping a field element to a boolean without 'if' statements.
template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    // Witness generation: if 'in' is not zero, 'inv' is its multiplicative inverse.
    // If 'in' is zero, 'inv' is set to 0 to avoid division by zero.
    // Note: <-- is for assignment (non-algebraic), used here for witness calculation.
    inv <-- in != 0 ? 1/in : 0;

    // Constraint 1: This forces 'out' to be 1 if 'in' is 0, and 0 otherwise.
    // Logic: if in != 0, then in*inv = 1, so out = -1 + 1 = 0.
    // Logic: if in == 0, then 0*inv = 0, so out = 0 + 1 = 1.
    out <== -in * inv + 1;

    // Constraint 2: Soundness check.
    // This ensures that 'out' MUST be 0 if 'in' is non-zero.
    // Without this, a malicious prover could choose an arbitrary 'inv' to force out=1.
    in * out === 0;
}
