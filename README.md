## Run tests

```bash
# Build the VM test
nix build --no-link --print-out-paths .#tests.default

# Run a Python test shell inside the test VM
nix run .#tests.default.vm.run -- --debug

# Run test VM. No tests are executed.
nix run .#tests.default.vmWithoutTests

# Run test node in a container. Requires extra-container, systemd and root privileges
nix run .#tests.default.container
# Run a command in a container
nix run .#tests.default.container -- --run c systemctl status tux-bitcoin

# Use the following cmds on NixOS with `system.stateVersion` <22.05
nix run .#tests.default.containerLegacy
nix run .#tests.default.containerLegacy -- --run c systemctl status tux-bitcoin
```
