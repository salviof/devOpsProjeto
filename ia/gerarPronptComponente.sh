#!/usr/bin/env bash
#
# Caramelo Code — monta o system prompt do composite component e chama o Claude Code.
# - Os 2 primeiros arquivos são o par do componente (.xhtml e .css), em qualquer ordem,
#   no mesmo diretório.
# - Depois deles, arquivos EXTRAS opcionais (relativos ao diretório atual ou absolutos),
#   que podem estar em qualquer lugar. São listados no modelo e têm suas pastas liberadas.
# - resources do PROJETO ATUAL: detectado do PWD (primeiro "resources").
# - SBComp (framework: CRC, componentes, libs): caminho FIXO do carameloCode.
#
# Uso:
#   gerarPronptComponente.sh <xhtml> <css> [extra1 extra2 ...] [-- <args do claude>]
#
set -euo pipefail

# --- caminhos fixos -----------------------------------------------------------
MODELO="/home/superBits/superBitsDevOps/devOpsProjeto/ia/CLAUDE.modeloComponente.md"
SBCOMP="/home/superBits/projetos/carameloCode/source/projeto/webApp/src/main/webapp/resources/SBComp"

# --- resources do PROJETO ATUAL (primeiro "resources" do PWD) -----------------
case "$PWD" in
  */resources/*) RESOURCES_DIR="${PWD%%/resources/*}/resources" ;;
  */resources)   RESOURCES_DIR="$PWD" ;;
  *) echo "Não encontrei 'resources' no caminho atual:" >&2
     echo "  $PWD" >&2
     echo "Rode de dentro do projeto (em resources ou abaixo dele)." >&2
     exit 1 ;;
esac

# --- separa arquivos (até "--") dos args extras do claude ---------------------
FILES=()
while [[ $# -gt 0 && "$1" != "--" ]]; do FILES+=("$1"); shift; done
[[ "${1:-}" == "--" ]] && shift
CLAUDE_ARGS=("$@")

[[ ${#FILES[@]} -ge 2 ]] || {
  echo "uso: $(basename "$0") <xhtml> <css> [extras...] [-- args do claude]" >&2
  exit 1
}

# --- par principal: os 2 primeiros, detectados por extensão -------------------
XHTML_IN=""; CSS_IN=""
for a in "${FILES[0]}" "${FILES[1]}"; do
  case "$a" in
    *.xhtml) XHTML_IN="$a" ;;
    *.css)   CSS_IN="$a" ;;
    *) echo "Os 2 primeiros devem ser um .xhtml e um .css. Recebido: $a" >&2; exit 1 ;;
  esac
done
[[ -n "$XHTML_IN" ]] || { echo "Falta o arquivo .xhtml" >&2; exit 1; }
[[ -n "$CSS_IN"   ]] || { echo "Falta o arquivo .css"   >&2; exit 1; }

# extras = do terceiro em diante
EXTRAS=("${FILES[@]:2}")

# --- resolve para caminho absoluto normalizado (colapsa ../ e ./) -------------
# realpath -ms: normaliza sem exigir que o arquivo exista e sem seguir symlink.
to_abs() {
  realpath -ms -- "$1" 2>/dev/null \
    || case "$1" in /*) printf '%s' "$1" ;; *) printf '%s' "$PWD/$1" ;; esac
}
XHTML="$(to_abs "$XHTML_IN")"
CSS="$(to_abs "$CSS_IN")"

# --- validação ----------------------------------------------------------------
[[ -f "$MODELO" ]] || { echo "Modelo não encontrado: $MODELO" >&2; exit 1; }

# --- --add-dir sem duplicar ---------------------------------------------------
declare -A seen=()
ADD_DIRS=()
add_dir() {
  local d="$1"
  if [[ -n "$d" && -z "${seen[$d]:-}" ]]; then
    seen["$d"]=1
    ADD_DIRS+=(--add-dir "$d")
  fi
  return 0
}

# --- monta a lista de "outros arquivos" e libera suas pastas ------------------
OUTROS_BLOCK=""
for e in ${EXTRAS[@]+"${EXTRAS[@]}"}; do
  ea="$(to_abs "$e")"
  OUTROS_BLOCK+="- ${ea}"$'\n'
  add_dir "$(dirname "$ea")"
done
if [[ -n "$OUTROS_BLOCK" ]]; then
  OUTROS_BLOCK="${OUTROS_BLOCK%$'\n'}"   # tira o \n final
else
  OUTROS_BLOCK="(nenhum nesta execução)"
fi

add_dir "$(dirname "$XHTML")"
add_dir "$(dirname "$CSS")"
add_dir "$RESOURCES_DIR"
add_dir "$SBCOMP"

# --- monta o prompt -----------------------------------------------------------
# 1) placeholders de linha única via sed (| como delimitador)
BASE="$(
  sed \
    -e "s|{{XHTML}}|${XHTML}|g" \
    -e "s|{{CSS}}|${CSS}|g" \
    -e "s|{{RESOURCES}}|${RESOURCES_DIR}|g" \
    -e "s|{{SBCOMP}}|${SBCOMP}|g" \
    "$MODELO"
)"
# 2) lista multilinha via awk (evita problemas de escape do sed)
PROMPT="$(
  printf '%s' "$BASE" | OUTROS_BLOCK="$OUTROS_BLOCK" awk '
    index($0, "{{OUTROS_ARQUIVOS}}") { print ENVIRON["OUTROS_BLOCK"]; next }
    { print }
  '
)"

# --- chama o Claude Code ------------------------------------------------------
exec claude "${ADD_DIRS[@]}" --append-system-prompt "$PROMPT" ${CLAUDE_ARGS[@]+"${CLAUDE_ARGS[@]}"}
