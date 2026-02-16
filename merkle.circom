pragma circom 2.1.0;

// @title MerkleTreeVerifier
// @author ZK_Topologist
// @notice Verifies a Merkle inclusion proof for a given root.
// @dev This circuit demonstrates the power of O(log n) verification for data sets.

include "node_modules/circomlib/circuits/poseidon.circom";

template MerkleTreeVerifier(height) {
    signal input leaf;                  // The secret data (leaf)
    signal input path_elements[height]; // The sibling hashes along the path
    signal input path_indices[height];  // Binary path: 0 for left, 1 for right
    signal input root;                  // The public commitment (Root)

    signal hashes[height + 1];
    hashes[0] <== leaf;

    component poseidons[height];

    for (var i = 0; i < height; i++) {
        // --- SECURITY CONSTRAINT ---
        // Ensure that path_indices are strictly binary (0 or 1).
        // This prevents "bit-smuggling" attacks where index values != {0,1} 
        // could break the algebraic integrity of the selector.
        path_indices[i] * (1 - path_indices[i]) === 0;

        poseidons[i] = Poseidon(2);

        // --- ALGEBRAIC SELECTOR ---
        // We use an algebraic formula to swap Left and Right inputs based on path_indices.
        // If path_indices[i] == 0: L = hashes[i], R = path_elements[i]
        // If path_indices[i] == 1: L = path_elements[i], R = hashes[i]
        // Formula: L = a + s*(b-a)
        
        signal left <== hashes[i] + path_indices[i] * (path_elements[i] - hashes[i]);
        signal right <== path_elements[i] + path_indices[i] * (hashes[i] - path_elements[i]);

        poseidons[i].inputs[0] <== left;
        poseidons[i].inputs[1] <== right;

        hashes[i+1] <== poseidons[i].out;
    }

    // --- INTEGRITY CHECK ---
    // The final computed hash must match the public Merkle Root.
    root === hashes[height];
}

// Instance for a tree of height 2 (supporting 4 leaves)
component main {public [root]} = MerkleTreeVerifier(2);
