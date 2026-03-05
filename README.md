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
Implementation of recursive hashing structures used in ZK-Rollups and privacy protocols (e.g., Tornado Cash).

- **Technical Detail**: The circuit reconstructs the Merkle Path by hashing nodes using the **Poseidon Hash**. It leverages an algebraic selector $L = a + s(b - a)$ to enforce the correct order of sibling nodes without conditional branching.
- **Security Audit**: Focuses on **Path Index Constraints**. My implementation enforces $s(1-s) = 0$ to prevent "bit-smuggling" attacks where a malicious prover could use non-binary index values to manipulate the computed root.

---

## 🛡️ 3. Security Deep Dives & Vulnerability Analysis
Beyond simple implementation, I document critical algebraic vulnerabilities that affect modern ZK protocols.

- **`AliasAttack_Notes.md` (Field Overflow)**: An analysis of the discrepancy between Finite Field arithmetic ($\mathbb{F}_p$) and external system representations (e.g., Ethereum's `uint256`). This documents how the lack of uniqueness in the solution space ($X \equiv X + p$) can lead to **Double Spending** or **Identity Forgery**.
- **`Poseidon_Security_Notes.md` (Symmetry Breaking)**: A deep dive into the algebraic security of ZK-friendly hashes.
  - **Round Constants**: Analyzing the importance of **Nothing-Up-My-Sleeve (NUMS)** constants to break algebraic symmetries and prevent **Invariant Subspace Attacks**.
  - **MDS Matrices**: Examining optimal diffusion through Maximum Distance Separable matrices to ensure that every input change propagates through the entire state.

---

## 🔬 Methodology & Philosophy
Every circuit in this repository is audited with a focus on **formal soundness**. My goal is to ensure that the R1CS constraints define a unique and intended solution space, leaving zero degrees of freedom for a malicious prover to generate forged proofs. 

In the world of Zero-Knowledge, **if a signal is not explicitly constrained, it is a vulnerability.**
