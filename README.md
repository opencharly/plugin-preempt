# plugin-preempt

Exclusive/shared resource arbitration for OpenCharly — the resource arbiter and
the `charly preempt` operator CLI.

The plugin owns the arbiter that coordinates exclusive claims across deployments:
acquire/release of exclusive and shared leases, stopping and restoring
preemptible holders, a crash-safe lease ledger
(`~/.local/share/charly/preemption/leases.yml`), GPU-resource poisoning, owner
liveness, and the `vfio`↔`nvidia` driver-mode arbitration. It is a **compiled-in**
charly plugin (listed in `charly/charly.yml` `compiled_plugins:`).

## What it provides

| Capability | Surface |
|---|---|
| `verb:arbiter` | the exclusive/shared resource arbiter — acquire/release leases, stop + restore preemptible holders, lease ledger, driver-mode math |
| `command:preempt` | the `charly preempt status` / `charly preempt restore` operator CLI |

## How to use it

Compose the plugin candy where a deployment must arbitrate a host resource:

```yaml
- '@github.com/opencharly/plugin-preempt/candy/plugin-preempt:<tag>'
```

A deployment claims a resource with `requires_exclusive:` and yields one with
`preemptible:`:

```yaml
my-pod:
    pod:
        image: some-image
        requires_exclusive:
            - gpu
```

Inspect live leases from the host with `charly preempt status`.

## R10 witness beds

The repo's root `charly.yml` declares its own disposable `disposable: true` beds
that prove the arbiter end-to-end with **zero GPU** (synthetic selector-less
tokens): `check-preempt-arbiter-pod`, `check-preempt-live-pod`,
`check-preempt-vm-live`, and the host-side `check-preempt-local` command bed.
They exercise the externalized dispatch over the in-proc reverse channel, the
`resolved-project` envelope, and the persistent lease ledger.

## Layout

- `candy/plugin-preempt/` — the plugin module: `arbiter.go` / `arbiter_support.go`
  (the arbiter), `command.go` (the `charly preempt` grammar), `holder_dispatch.go`
  (stop/start over the reverse channel), `schema/preempt.cue`,
  `params/cue_types_gen.go`, `cmd/serve/main.go`.
- `charly.yml` — the root project manifest (`discover: candy` + the witness beds).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.

## Platforms

Builds for `linux/amd64`, `linux/arm64`, `linux/arm/v7` and `linux/386`. The
32-bit targets work because of the sdk's 32-bit fix
([opencharly/sdk#263](https://github.com/opencharly/sdk/pull/263), issue
[#262](https://github.com/opencharly/sdk/issues/262)) — `charly`'s loader
host-builds this plugin with `CGO_ENABLED=0`, so the artifact is a static binary,
which is what a 32-bit appliance without a glibc toolchain (such as a JetKVM's
uClibc armv7 userland) runs.

## Related

- Owning skill: `/charly-internals:disposable` — the `disposable:`/`preemptible:`
  flag semantics and exclusive host-resource arbitration. This candy carries no
  `skill:` entity of its own; the gap is tracked in
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- `/charly-core:deploy` — the `requires_exclusive:` deploy surface.
- `/charly-internals:plugin` — the plugin/provider model.
