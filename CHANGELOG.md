## 0.0.3-beta

- Added reusable Beta Analysis Engine components:
	- `BetaAnalysisService`
	- `BetaAnalysisResult`
	- `BetaMetricsSnapshot`
	- `DistributionMetric`
	- `BetaReleaseDecision`
	- `BetaConfidenceScore`
	- `ActionPlanItem`
- Added offline export mode in `tools/export_beta_reports.dart` via `--input-json`.
- Expanded generated executive report (`beta_summary.md`) with:
	- release decision section
	- beta confidence score section
	- 48h action plan section
	- advanced UX metrics sections
- Enriched AI correction prompt with decision, scoring, action-plan priorities, constraints, and expected response format.
- Added official demo fixture: `example/data/sample_beta_reports.json`.
- Added and extended unit tests for analysis engine distributions, release decision, confidence score, and action-plan generation.

## 0.0.2-alpha

- Added strict BUSKIA parity UX block with optional configurable fields:
	- interface evaluation
	- color evaluation
	- usability evaluation
- Extended `BetaFeedbackFieldConfig` with backward-compatible flags (default `false`).
- Extended `BetaFeedbackReport` with nullable optional fields for the new UX block.
- Extended `beta_feedback_sheet` payload handling (`[btf_form_v1]`) to save/restore new fields.
- Extended markdown generation to include new UX fields only when values are present.
- Improved submit failure UX in modal:
	- inline error message in form
	- auto-scroll to error visibility
	- modal remains open with preserved input and re-enabled submit button
- Updated example app to enable advanced BUSKIA fields for visual validation.
- Added/updated tests for config defaults, report mapping compatibility, draft restore, markdown conditional output, and submit-failure UX.

## 0.0.1

- Initial SDK baseline release.
