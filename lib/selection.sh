#!/bin/bash
# lib/selection.sh — seleção de itens por tag estável "MODULO:funcao".

# Consumido por track() (lib/results.sh) e pelo catálogo.
# shellcheck disable=SC2034
SELECTION_ENABLED=false
declare -gA SELECTED_TAGS=()

select_add() {
  local tag="${1:?tag obrigatória}"
  SELECTED_TAGS["$tag"]=1
}

select_clear() {
  SELECTED_TAGS=()
}

select_has() {
  local tag="${1:-}"
  [ -n "$tag" ] && [ -n "${SELECTED_TAGS[$tag]:-}" ]
}

select_count() {
  printf '%s\n' "${#SELECTED_TAGS[@]}"
}

select_summary() {
  printf '%s item(ns) selecionado(s)\n' "$(select_count)"
}
