#!/bin/bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"
shellcheck "$DIR"/*.sh "$DIR"/lib/*.sh "$DIR"/install/*.sh
