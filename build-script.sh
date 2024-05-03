#!/bin/bash
export NIX_SSHOPTS='-tt';
time { nixos-rebuild --flake .#nixos-vm --target-host rizqirazkafi@192.168.122.210 --use-remote-sudo switch -L; };
