# Stats Benchmark
**Stand:** 2026-03-15

Optionaler Benchmark-Runner fuer Stats-Pfade (nicht Teil von `make verify`).

## Ziel

- reproduzierbare Laufzeitmessung fuer definierte Stats-Commands
- trigger-basierte Performance-Entscheidung statt Bauchgefuehl

## Runner

- Script: `tests/benchmark/run_stats_benchmark.sh`
- Standard-Fixture: `tests/domain_policy/fixtures/Betankungen_Big.db`
- Fixture wird bei Bedarf automatisch erzeugt.

## Beispiel

```bash
tests/benchmark/run_stats_benchmark.sh --iterations 5 --warmup 1
```

Optional JSON-Protokoll:

```bash
tests/benchmark/run_stats_benchmark.sh --iterations 5 --json-out .artifacts/benchmarks/stats_bench.json
```

## Messfaelle

- `fuelups_text`
- `fuelups_json`
- `fleet_json`
- `cost_json_none`
- `cost_json_scoped`
