# SA transaction method coverage (UVM 1.2 / Questa)

The file `sa_transaction.svh` overrides all seven requested `uvm_object` hooks. Each is invoked through its public UVM API, rather than calling a protected implementation hook directly.

| Hook | Where/how used | Purpose |
| --- | --- | --- |
| `convert2string()` | `sa_test.exercise_transaction_methods`, input/output monitors | Compact formatted diagnostic string |
| `do_copy()` | `copied.copy(original)` and scoreboard `actual_normalized.copy(actual)` | Clone the field values |
| `do_compare()` | `original.compare(copied,cmp)` and scoreboard `expected.compare(actual_normalized,cmp)` | Field-by-field comparison with UVM mismatch reporting |
| `do_print()` | `original.sprint()` | Standard UVM printable representation |
| `do_record()` | `original.record(rec)` | Feed a recorder with individual field values; database output is simulator-dependent |
| `do_pack()` | `original.pack_bits(packed_bits)` | Serialize exactly 7 field bits |
| `do_unpack()` | `decoded.unpack_bits(packed_bits)` | Restore three fields and verify the round trip |

`sa_test` performs a positive copy/compare, print, record, pack/unpack round trip, and deliberately mismatched compare before starting the normal serial-adder stimulus. This is also a functional smoke test of the methods. The deliberate comparison mismatch can cause **diagnostic comparer messages** depending on UVM configuration; it is expected and must not be confused with a DUT failure.

**Important:** The DUT output monitor does not observe operand values. The scoreboard makes a temporary normalized copy of the actual transaction, fills its `ina` and `inb` from the paired expected transaction, then calls the object's `compare()` so all fields are compared consistently. This assumes in-order response pairing.

## Run

From `UVM/` in Questa after building the external C++ DPI predictor DLL/shared library:

```tcl
set PREDICT_LIB path/to/predict_library_without_extension
do sim_ver_sa.do
```

Check for `SA_METHODS_PASS` and `ADDER_SUMMARY` in the UVM report.

**Validation limitations:** Source editing and static inspection completed. The environment has no Questa/UVM installation, so simulator compilation, recorder backend, and end-to-end VHDL/UVM timing have not been executed here.
