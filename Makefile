# CREATED: 2026-03-12
# UPDATED: 2026-03-14

SHELL := bash
.SHELLFLAGS := -e -o pipefail -c

FPC_BUILD_CMD := fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr

.PHONY: help build lint-docs tracker-lint contract-check cost-integration-check policy smoke-fixtures smoke smoke-clean verify release-dry

help:
	@echo "Verfuegbare Targets:"
	@echo "  make build         - FPC-Standardbuild (bin/build/units)"
	@echo "  make verify        - Lokales CI-Gate (Docs-Lint + Tracker-Lint + Build + Contract + Policy + Smokes)"
	@echo "  make cost-integration-check - Regression fuer Cost-Integrationsmodi (none/module/fallback)"
	@echo "  make smoke         - Smoke-Suite (tests/smoke/smoke_cli.sh --modules)"
	@echo "  make smoke-clean   - Clean-Home-Smoke (tests/smoke/smoke_clean_home.sh --modules)"
	@echo "  make release-dry   - Dry-Run fuer Release-Archiv (kpr.sh --dry-run)"

build:
	mkdir -p bin build units
	$(FPC_BUILD_CMD)

lint-docs:
	scripts/sprint_docs_lint.sh

tracker-lint:
	scripts/projtrack_lint.sh

contract-check:
	tests/regression/run_export_contract_json_check.sh

cost-integration-check:
	tests/regression/run_cost_integration_modes_check.sh

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

verify: lint-docs tracker-lint build contract-check cost-integration-check policy smoke-fixtures smoke smoke-clean

release-dry:
	./kpr.sh --dry-run
