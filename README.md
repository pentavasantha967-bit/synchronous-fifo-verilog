# Synchronous FIFO Using Verilog HDL

## Overview
This project implements a synchronous First-In, First-Out (FIFO)
buffer using Verilog HDL.

A FIFO stores data temporarily and outputs it in the same order
in which it was written. Read and write operations use a common clock.

## Features
- Parameterized data width and FIFO depth
- Synchronous read and write operations
- Read and write pointers
- Full and empty status flags
- Pointer wrap-around
- Reset support
- Handling of simultaneous read and write requests

## Default Configuration
- Data width: 8 bits
- FIFO depth: 16 entries
- Clock: Single clock domain
- HDL: Verilog

## Project Files
- `sync_fifo.v` — RTL implementation
- `sync_fifo_tb.v` — Testbench (to be added)

## Concepts Demonstrated
- FIFO architecture
- Memory arrays
- Read and write pointers
- Occupancy counting
- Status flag generation
- Sequential logic

## Verification
Simulation results and test cases will be added after testing
the RTL implementation.

## Future Improvements
- Develop a self-checking testbench
- Test full and empty conditions
- Test pointer wrap-around
- Test simultaneous read and write operations
- Add simulation waveforms
