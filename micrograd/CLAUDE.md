# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies (uses uv)
uv sync

# Run all tests (requires PyTorch installed separately)
python -m pytest

# Run a single test
python -m pytest test/test_engine.py::test_sanity_check
```

Tests use PyTorch as a reference implementation to verify gradient correctness, so PyTorch must be available in the environment.

## Architecture

This is a scalar-valued autograd engine with a neural network library on top.

**`micrograd/engine.py` — `Value` class**
The core. Each `Value` wraps a single scalar and records its `_prev` (parent nodes) and `_op` (the operation that produced it), forming a dynamically built DAG. Every arithmetic operation defines a `_backward` closure that accumulates gradients using the chain rule. Calling `.backward()` on a leaf performs a topological sort of the DAG and calls each node's `_backward` in reverse order.

**`micrograd/nn.py` — neural network modules**
Builds on `Value`. `Module` is the base class with `zero_grad()` and `parameters()`. The hierarchy is `Neuron → Layer → MLP`. All weights/biases are `Value` objects, so the full computation graph is built during the forward pass and backprop flows through automatically.

**Key design constraint**: operates only on scalar values — no tensors or batching. Each neuron computes scalar dot products. This makes the code simple but slow; it's intentionally educational.
