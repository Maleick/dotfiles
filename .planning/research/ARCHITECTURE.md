# Architecture Research

**Domain:** Verification wrapper mode expansion and compatibility evidence pipeline
**Researched:** 2026-02-25
**Confidence:** HIGH

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   Operator Invocation Layer                │
├─────────────────────────────────────────────────────────────┤
│  ./scripts/verify-suite.sh [mode flags]                    │
└───────────────┬─────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────┐
│                Verification Orchestration Layer             │
├─────────────────────────────────────────────────────────────┤
│  mode parser -> check planner -> check runner -> reporter   │
└───────────────┬─────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────┐
│                    Evidence Contract Layer                  │
├─────────────────────────────────────────────────────────────┤
│  PASS/FAIL/SKIP rows + summary + optional machine payload   │
└───────────────┬─────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────┐
│                 Compatibility Artifact Layer                │
├─────────────────────────────────────────────────────────────┤
│  .planning/compatibility/v1.1-matrix.md + docs references   │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| Wrapper entrypoint | Parse mode flags and run deterministic check sequences | `scripts/verify-suite.sh` with explicit mode routing and shared helpers |
| Check catalog | Define required vs optional checks and quick/full inclusion | Shell functions with check metadata and execution guards |
| Reporter | Emit human-readable and machine-readable outputs without drift | Shared status object formatted into both output channels |
| Matrix updater flow | Convert observed run evidence into canonical matrix row updates | Structured helper functions or phase-scoped script with explicit schema enforcement |

## Recommended Project Structure

```
scripts/
├── verify-suite.sh                 # canonical wrapper entrypoint
├── verify-suite-lib.sh             # optional shared mode/check/report helpers
└── compatibility/
    └── update-matrix.sh            # optional evidence-to-row update helper

.planning/
├── compatibility/
│   └── v1.1-matrix.md              # canonical compatibility artifact
└── phases/
    └── 0X-.../                     # verification evidence reports per phase
```

### Structure Rationale

- **`scripts/verify-suite.sh`:** Keeps stable operator contract with one command entrypoint.
- **`scripts/compatibility/` helpers:** Allows schema/evidence logic growth without overloading entrypoint script.
- **`.planning/compatibility/`:** Maintains human-auditable compatibility source-of-truth file.

## Architectural Patterns

### Pattern 1: Shared Check Metadata, Multiple Views

**What:** Model check results once and render both human and machine views from the same data.
**When to use:** Adding machine-readable output while preserving existing text contract.
**Trade-offs:** Slightly more script structure upfront; far less drift risk later.

### Pattern 2: Mode Gating with Contract Minimums

**What:** Quick mode runs a strict required subset, full mode runs all required+optional checks.
**When to use:** Need faster loops without sacrificing reliability signal.
**Trade-offs:** Requires explicit governance of which checks are mandatory in quick mode.

### Pattern 3: Evidence-Backed Documentation Updates

**What:** Matrix row updates must cite observed command references and validation dates.
**When to use:** Any compatibility status change.
**Trade-offs:** Slower updates than inferred edits, but higher trust and traceability.

## Data Flow

### Request Flow

```
[Operator runs verify-suite]
    ↓
[Mode parse]
    ↓
[Execute selected checks]
    ↓
[Collect status records]
    ↓
[Render text output + optional machine payload]
    ↓
[Optional matrix update using observed records]
```

### State Management

```
[Check Catalog]
    ↓
[Runner]
    ↓
[In-memory result set]
    ├──> [Text reporter]
    ├──> [Machine reporter]
    └──> [Matrix row generator]
```

### Key Data Flows

1. **Verification execution flow:** wrapper command to check status records and deterministic summary.
2. **Compatibility evidence flow:** observed result set to matrix row updates with caveat tags and dates.

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| Single operator local use | Keep shell-only implementation with clear mode flags |
| Multi-host manual validation | Add environment-profile arguments to matrix update helper |
| Frequent automated validation | Add schema checks and output versioning before CI integration |

### Scaling Priorities

1. **First bottleneck:** mode/output drift between text and machine contracts.
2. **Second bottleneck:** inconsistent matrix row authoring and caveat quality.

## Anti-Patterns

### Anti-Pattern 1: Dual Execution Paths with Separate Logic

**What people do:** Implement quick/full or text/machine modes as separate disconnected command paths.
**Why it's wrong:** Behavior diverges and verification trust degrades.
**Do this instead:** Share execution core and branch only in reporting or check selection layers.

### Anti-Pattern 2: Matrix Updates Without Evidence Provenance

**What people do:** Manually edit matrix status to PASS based on expectation.
**Why it's wrong:** Produces untraceable claims and brittle operator assumptions.
**Do this instead:** Require command references and last-validated date on every updated row.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| None required | Local terminal tooling only | Keep phase scope local-first and read-only |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| `verify-suite` ↔ runtime config files | direct CLI checks | Must remain non-mutating |
| `verify-suite` ↔ matrix artifact | evidence data transfer | Enforce schema and caveat tags |
| wrapper behavior ↔ docs contracts | markdown updates | README and AGENTS must reflect latest mode semantics |

## Sources

- `scripts/verify-suite.sh`
- `.planning/compatibility/v1.1-matrix.md`
- `.planning/phases/05-validation-wrapper-baseline/05-VERIFICATION.md`
- `.planning/phases/06-compatibility-matrix-and-coverage/06-VERIFICATION.md`
- `README.md`
- `AGENTS.md`

---
*Architecture research for: v1.2 automation expansion*
*Researched: 2026-02-25*
