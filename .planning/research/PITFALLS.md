# Pitfalls Research — v1.3 Automation Hardening

## Common Failure Modes

### 1) Breaking existing JSON consumers

Risk:
- Renaming/removing existing keys while adding schema versioning.

Prevention:
- Additive schema metadata only.
- Preserve `checks` and `summary` field semantics exactly.
- Include compatibility smoke checks against previous expected shape.

### 2) Ambiguous schema version meaning

Risk:
- Version field exists but lacks clear compatibility policy.

Prevention:
- Define explicit compatibility guarantees in docs.
- Tie major/minor changes to concrete rules (breaking vs non-breaking).

### 3) Coverage expansion without observed evidence

Risk:
- Marking new profile rows `PASS`/`FAIL` without command evidence.

Prevention:
- Enforce observed-run-only claim policy.
- Use `SKIP` with explicit caveat when environment not observed.

### 4) Matrix key drift across profile naming

Risk:
- Duplicate logical profiles due to inconsistent naming.

Prevention:
- Standardize environment profile naming conventions.
- Keep deterministic keying and update-in-place behavior.

### 5) Scope creep into CI/pipelines

Risk:
- Expanding milestone into publication/CI integration work.

Prevention:
- Keep phase goals tied strictly to `AUTO-06` and `COMP-04`.
- Defer CI publication features explicitly to future milestone.

## Phase Placement Guidance

- Address JSON contract stability pitfalls in early phase (AUTO-06).
- Address evidence integrity and profile normalization pitfalls in follow-on phase (COMP-04).
