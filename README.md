# ZK-Learning 
### Mathematical Exploration of Zero-Knowledge Circuits

This repository contains my personal implementations and security notes on ZK circuits using **Circom**. 
As a **PhD in Mathematics**, my objective is to bridge the gap between abstract algebraic structures and the practical implementation of ZK-SNARKs, focusing on the **soundness** and **algebraic integrity** of R1CS constraints.

---

## 🛠 1. Fundamental Logic Gadgets
These components form the basis of ZK arithmetic logic, where conditional branching is replaced by polynomial constraints.

- `IsZero.circom`: An algebraic mapping of field elements to booleans. It demonstrates the use of multiplicative inverses in $\mathbb{F}_p$ to bypass the lack of native `if` statements.
- `Num2Bits.circom`: Binary decomposition. A critical component for range-check fundamentals, ensuring that a field element belongs to a specific bit-width.
- `LessThan.circom`: Inequality logic. It utilizes the bit-sign detection trick ($2^n + a - b$) to enforce order relations in prime fields.

---

## 🌲 2. Privacy & State Management: Merkle Inclusion Proofs
The Merkle Tree Verifier is a cornerstone of privacy-preserving protocols (e.g., anonymous transfers, ZK-Rollups). It allows a Prover to demonstrate that a specific secret data point (leaf) exists within a public commitment (the Root) without revealing the leaf's value or its position.

### Technical Implementation
- **Hashing**: Utilizes the **Poseidon Hash**, a ZK-friendly unkeyed permutation. Unlike SHA-256, Poseidon is optimized for R1CS, leveraging MDS matrices and $x^5$ S-boxes to minimize the constraint count in the prime field $\mathbb{F}_p$.
- **Recursive Logic**: The circuit reconstructs the Merkle Path by hashing the current node with its sibling at each level $i \in \{0, \dots, height-1\}$.
- **Algebraic Selector**: Since R1CS lacks native conditional branching, the left/right node order is enforced via a linear multiplexer: 
  $L = a + s(b - a)$  
  $R = b + s(a - b)$  
  where $s \in \{0, 1\}$ is the path index.

### Security & Audit Considerations
- **Path Index Constraint**: A critical vulnerability in Merkle circuits is the lack of binary constraints on `path_indices`. My implementation enforces $s(1-s) = 0$ for every step. Without this, a malicious prover could inject non-binary values to manipulate the hash computation and forge inclusion proofs.
- **Algebraic Integrity**: By using Poseidon, we ensure that the proof generation remains computationally efficient while maintaining a security level of ~128 bits against differential and algebraic attacks (e.g., Gröbner basis attacks).

---

## 🔬 Methodology & Philosophy
Every circuit in this repository is audited with a focus on **formal soundness**. My goal is to ensure that the R1CS constraints define a unique and intended solution space, leaving zero degrees of freedom for a malicious prover to generate forged proofs. In the world of Zero-Knowledge, **if a signal is not explicitly constrained, it is a vulnerability.**
