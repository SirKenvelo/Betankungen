# CREATED: 2026-03-12
# UPDATED: 2026-03-24

SHELL := bash
.SHELLFLAGS := -e -o pipefail -c

FPC_BUILD_CMD := fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr

.PHONY: help build lint-docs tracker-lint contract-check contract-check-json contract-check-csv cost-integration-check db-backup-ops-check fuel-price-history-check receipt-link-check user-flow-break-check package-manifest-check wiki-link-check policy smoke-fixtures smoke smoke-clean verify stats-benchmark release-preflight release-preflight-1-0-0 release-preflight-1-1-0 release-dry

help:
	@echo "Verfuegbare Targets:"
	@echo "  make build         - FPC-Standardbuild (bin/build/units)"
	@echo "  make verify        - Lokales CI-Gate (Docs-Lint + Tracker-Lint + Build + Contract + Policy + Smokes)"
	@echo "  make cost-integration-check - Regression fuer Cost-Integrationsmodi (none/module/fallback)"
	@echo "  make db-backup-ops-check - Regression fuer Multi-DB-Backup-Operations (single/all/dry-run/retention)"
	@echo "  make fuel-price-history-check - Regression fuer getrennten Preis-Historienpfad (runner/raw/db/state)"
	@echo "  make receipt-link-check - Regression fuer Receipt-Link-Contract (Scope/Write-Path/Text+JSON)"
	@echo "  make user-flow-break-check - Priorisierte User-Flow-/Break-Matrix-Checks aus TSK-0012"
	@echo "  make package-manifest-check - Optionaler Fixture-Check fuer Export-Package-Manifest v1"
	@echo "  make wiki-link-check - Guardrail-Check fuer Wiki-v1-Quellseiten"
	@echo "  make stats-benchmark - Optionaler Benchmark-Runner fuer Stats-Pfade"
	@echo "  make smoke         - Smoke-Suite (tests/smoke/smoke_cli.sh --modules)"
	@echo "  make smoke-clean   - Clean-Home-Smoke (tests/smoke/smoke_clean_home.sh --modules)"
	@echo "  make release-preflight - Readiness-Preflight (verify + release dry-runs)"
	@echo "  make release-preflight-1-0-0 - 1.0.0 Readiness-Preflight (verify + release dry-runs)"
	@echo "  make release-preflight-1-1-0 - 1.1.0 Readiness-Preflight (verify + release dry-runs)"
	@echo "  make release-dry   - Dry-Run fuer Release-Archiv (kpr.sh --dry-run)"

build:
	mkdir -p bin build units
	$(FPC_BUILD_CMD)

lint-docs:
	scripts/sprint_docs_lint.sh

tracker-lint:
	scripts/projtrack_lint.sh

contract-check: contract-check-json contract-check-csv

contract-check-json:
	tests/regression/run_export_contract_json_check.sh

contract-check-csv:
	tests/regression/run_export_contract_csv_check.sh

cost-integration-check:
	tests/regression/run_cost_integration_modes_check.sh

db-backup-ops-check:
	tests/regression/run_db_backup_ops_check.sh

fuel-price-history-check:
	tests/regression/run_fuel_price_history_check.sh

receipt-link-check:
	tests/regression/run_receipt_link_contract_check.sh

user-flow-break-check:
	tests/regression/run_user_flow_break_matrix_check.sh

package-manifest-check:
	tests/regression/run_package_manifest_fixture_check.sh

wiki-link-check:
	scripts/wiki_link_check.sh

policy:
	tests/domain_policy/run_domain_policy_tests.sh

smoke-fixtures:
	mkdir -p .releases .backup
	if ! ls .releases/Betankungen_*.tar >/dev/null 2>&1; then \
	  tar -cf .releases/Betankungen_0_0_0_local_verify.tar docs/README.md; \
	fi

smoke:
	tests/smoke/smoke_cli.sh --modules

smoke-clean:
	tests/smoke/smoke_clean_home.sh --modules

verify: lint-docs tracker-lint wiki-link-check build contract-check cost-integration-check db-backup-ops-check fuel-price-history-check receipt-link-check user-flow-break-check policy smoke-fixtures smoke smoke-clean

stats-benchmark:
	tests/benchmark/run_stats_benchmark.sh

release-preflight:
	scripts/release_preflight.sh

release-preflight-1-0-0:
	scripts/release_preflight_1_0_0.sh

release-preflight-1-1-0:
	scripts/release_preflight_1_1_0.sh

release-dry:
	./kpr.sh --dry-run
