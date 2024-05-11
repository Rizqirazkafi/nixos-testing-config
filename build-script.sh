#!/bin/bash
export NIX_SSHOPTS='-p 9005';
time { nixos-rebuild --flake .#nixos-vm --target-host root@$1 switch --verbose; };
