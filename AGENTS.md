# AGENTS.md — plugin-preempt

Standalone plugin repo for the resource arbiter (`verb:arbiter`) and the
`charly preempt` CLI (`command:preempt`). The plugin is a Go module at
`candy/plugin-preempt/` (module path
`github.com/opencharly/plugin-preempt/candy/plugin-preempt`); the root
`charly.yml` declares `discover: candy` **and** the disposable R10 witness beds.

Canonical files:

- `candy/plugin-preempt/charly.yml` — the `plugin-preempt:` candy entity
  (`plugin:` block, `plan:` checks).
- `candy/plugin-preempt/arbiter.go` / `arbiter_support.go` — the arbiter:
  acquire/release leases, stop + restore holders, the lease ledger, driver math.
- `candy/plugin-preempt/command.go` — the `charly preempt status`/`restore`
  Kong grammar and lease-table rendering.
- `candy/plugin-preempt/holder_dispatch.go` — holder stop/start over the reverse
  channel.
- `candy/plugin-preempt/schema/preempt.cue` — the self-contained input schema.
- `charly.yml` — the project manifest + the witness beds
  (`check-preempt-arbiter-pod`, `check-preempt-live-pod`,
  `check-preempt-vm-live`, `check-preempt-local`).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-internals:plugin` — the plugin authoring reference: the `plugin:`
  block, the unified Provider model, the per-plugin CUE-schema contract,
  placement. Load before touching the provider or schema.
- `/charly-internals:disposable` — the `disposable:`/`preemptible:` flag
  semantics and exclusive host-resource arbitration this plugin implements.
- `/charly-core:deploy` — the `requires_exclusive:` deploy surface.
- `/charly-check:check` — the disposable bed / R10 run sequence.
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `go build ./...` in `candy/plugin-preempt/` — compile the plugin module.
- `go test ./...` in `candy/plugin-preempt/` — the plugin's Go tests.
- `charly box validate` at the repo root — the structural check (the candy +
  `plugin:` block, CUE schema, the witness beds).
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate.
- R10 beds: run the `disposable: true` witness beds via `charly check run
  <bed>` (see `/charly-check:check`). They need no GPU — the tokens are
  selector-less.

## Modify this repo

- Edit the `plugin-preempt:` candy entity, the Go source, and
  `schema/preempt.cue` **together** — the schema is the single source for the
  `params/` struct, so a field change not mirrored in the schema desyncs the
  generated types.
- The plugin is **compiled-in**; the `cmd/serve` shim backs an out-of-process
  placement but the arbiter's hot-path seams require the in-proc reverse channel.
- The witness beds are load-bearing R10 evidence; keep them aligned with the
  arbiter behavior when it changes.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
