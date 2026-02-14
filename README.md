# ZK-Learning 
### Mathematical Exploration of Zero-Knowledge Circuits

This repository contains my personal implementations and notes on ZK circuits using **Circom**. 
As a **PhD in Mathematics**, my goal is to explore the soundness and algebraic integrity of ZK-SNARKs.

## Contents
- `IsZero.circom`: Algebraic mapping of field elements to booleans.
- `Num2Bits.circom`: Binary decomposition and range-check fundamentals.
- `LessThan.circom`: Inequality logic using bit-sign detection in finite fields.

## Methodology
Every circuit is audited with a focus on **soundness**, ensuring that the R1CS constraints fully define the intended logic without leaving degrees of freedom for a malicious prover.
