#!/usr/bin/env bash
# Claude Code status line, Catppuccin Mocha theme (24-bit truecolor), minimal.
#
# Line 1: model | effort | [bar] used/size (pct%)
# Line 2: repo | worktree | branch | (+added,-removed) | PR status
#
# Color rules: primary info in Text, secondary in Overlay, separators dim.
# Color is reserved for signal: the context bar, a warning as context grows,
# and non-zero diff counts.
#
# Performance: written for bash 3.2 (macOS /bin/bash) with as few forks as
# possible: 1 jq, 2 git, and 1 date when gh is installed. The PR lookup never
# blocks: a stale cache is shown while gh refreshes it in the background.

# ---------- palette (precomputed escapes, no subshells) ----------
RST=$'\033[0m'
TEXT=$'\033[38;2;205;214;244m'      # cdd6f4
SUBTEXT0=$'\033[38;2;166;173;200m'  # a6adc8
OVERLAY0=$'\033[38;2;108;112;134m'  # 6c7086
SURFACE0=$'\033[38;2;49;50;68m'     # 313244
SURFACE2=$'\033[38;2;88;91;112m'    # 585b70
LAVENDER=$'\033[38;2;180;190;254m'  # b4befe
GREEN=$'\033[38;2;166;227;161m'     # a6e3a1
YELLOW=$'\033[38;2;249;226;175m'    # f9e2af
PEACH=$'\033[38;2;250;179;135m'     # fab387
MAROON=$'\033[38;2;235;160;172m'    # eba0ac
RED=$'\033[38;2;243;139;168m'       # f38ba8

BAR_WIDTH=20
PR_TTL=60
SEP=" ${SURFACE2}|${RST} "

join_segments() {
  local out="" seg
  for seg in "$@"; do
    [ -n "$out" ] && out+="$SEP"
    out+="$seg"
  done
  printf '%s\n' "$out"
}

# Short token format without forking: 127k, 1.0M
short_tokens() {
  local n=$1 t
  if [ "$n" -ge 1000000 ]; then
    t=$(( (n + 50000) / 100000 ))
    REPLY="$(( t / 10 )).$(( t % 10 ))M"
  elif [ "$n" -ge 1000 ]; then
    REPLY="$(( (n + 500) / 1000 ))k"
  else
    REPLY="$n"
  fi
}

# ---------- parse JSON (single jq call) ----------
# Fields are joined with \x1f, a non-whitespace IFS, so empty fields survive.
IFS=$'\x1f' read -r model effort used size pct dir < <(
  jq -r '[
    .model.display_name, .effort.level,
    .context_window.total_input_tokens, .context_window.context_window_size,
    .context_window.used_percentage, (.workspace.current_dir // .cwd)
  ] | map(. // "" | tostring) | join("\u001f")' 2>/dev/null
)
[ -z "$dir" ] && dir=$PWD

# ---------- line 1 ----------
l1=()
[ -n "$model" ] && l1+=("${TEXT}${model}${RST}")
[ -n "$effort" ] && l1+=("${SUBTEXT0}${effort}${RST}")

size=${size%%.*}
if [ -n "$size" ] && [ "$size" -gt 0 ] 2>/dev/null; then
  used=${used%%.*}; used=${used:-0}
  if [ -n "$pct" ]; then
    printf -v pct_int '%.0f' "$pct" 2>/dev/null || pct_int=0
  else
    pct_int=$(( used * 100 / size ))
  fi

  filled=$(( pct_int * BAR_WIDTH / 100 ))
  [ "$filled" -gt "$BAR_WIDTH" ] && filled=$BAR_WIDTH
  [ "$filled" -lt 0 ] && filled=0
  [ "$filled" -eq 0 ] && [ "$pct_int" -gt 0 ] && filled=1

  bar_fill="" bar_empty=""
  for ((i = 0; i < filled; i++)); do bar_fill+="█"; done
  for ((i = filled; i < BAR_WIDTH; i++)); do bar_empty+="█"; done

  # Bar and percentage stay calm until context gets large (absolute tokens).
  if   [ "$used" -ge 500000 ]; then FILL=$RED;      PCT_COLOR=$RED
  elif [ "$used" -ge 400000 ]; then FILL=$MAROON;   PCT_COLOR=$MAROON
  elif [ "$used" -ge 300000 ]; then FILL=$PEACH;    PCT_COLOR=$PEACH
  elif [ "$used" -ge 200000 ]; then FILL=$YELLOW;   PCT_COLOR=$YELLOW
  else                              FILL=$LAVENDER; PCT_COLOR=$OVERLAY0
  fi

  short_tokens "$used"; used_s=$REPLY
  short_tokens "$size"; size_s=$REPLY
  l1+=("${OVERLAY0}[${FILL}${bar_fill}${SURFACE0}${bar_empty}${OVERLAY0}]${RST} ${SUBTEXT0}${used_s}/${size_s}${RST} ${PCT_COLOR}(${pct_int}%)${RST}")
fi

[ ${#l1[@]} -gt 0 ] && join_segments "${l1[@]}"

# ---------- line 2 ----------
l2=()
name=${dir%/}; name=${name##*/}; [ -z "$name" ] && name=/

# One rev-parse call answers "is this a repo", toplevel, git dir and common dir.
# It fails (prints nothing useful) outside a work tree.
rp=$(git -C "$dir" --no-optional-locks rev-parse --path-format=absolute \
       --show-toplevel --git-dir --git-common-dir 2>/dev/null)

if [ -n "$rp" ]; then
  { read -r top; read -r git_dir; read -r common_dir; } <<<"$rp"

  # In a linked worktree, the repo name comes from the main repo and the
  # worktree name follows it. In the main checkout the worktree is omitted.
  worktree=""
  if [ -n "$common_dir" ] && [ "$git_dir" != "$common_dir" ]; then
    main=${common_dir%/}; main=${main%/.git}; name=${main##*/}
    worktree=${top##*/}
  else
    name=${top##*/}
  fi
  l2+=("${TEXT}${name}${RST}")
  [ -n "$worktree" ] && l2+=("${SUBTEXT0}${worktree}${RST}")

  # Branch straight from HEAD, no git call. Detached HEAD shows the short SHA.
  branch=""
  if { read -r head < "$git_dir/HEAD"; } 2>/dev/null; then
    case "$head" in
      "ref: refs/heads/"*) branch=${head#ref: refs/heads/} ;;
      "ref: "*)            branch=${head#ref: } ;;
      *)                   branch=${head:0:7} ;;
    esac
  fi
  [ -n "$branch" ] && l2+=("${SUBTEXT0}${branch}${RST}")

  # Diff stats vs HEAD (staged + unstaged), summed in bash.
  added=0 removed=0
  while read -r a r _; do
    case "$a" in ''|*[!0-9]*) ;; *) added=$(( added + a )) ;; esac
    case "$r" in ''|*[!0-9]*) ;; *) removed=$(( removed + r )) ;; esac
  done < <(git -C "$dir" --no-optional-locks diff HEAD --numstat --no-ext-diff --no-renames 2>/dev/null)
  A_COLOR=$OVERLAY0; [ "$added" -gt 0 ] && A_COLOR=$GREEN
  R_COLOR=$OVERLAY0; [ "$removed" -gt 0 ] && R_COLOR=$RED
  l2+=("${OVERLAY0}(${A_COLOR}+${added}${OVERLAY0},${R_COLOR}-${removed}${OVERLAY0})${RST}")

  # PR status via gh. Cache file holds "<timestamp> <pr number or empty>".
  # A stale cache is still shown; gh refreshes it in the background.
  if [ -n "$branch" ] && command -v gh >/dev/null 2>&1; then
    key="${top}|${branch}"; key=${key//[^A-Za-z0-9._-]/_}
    [ ${#key} -gt 120 ] && key=${key:$(( ${#key} - 120 ))}
    cache="${TMPDIR:-/tmp}"; cache="${cache%/}/claude-statusline-pr-${key}"
    ts=0 pr="" have_cache=""
    if { read -r ts pr < "$cache"; } 2>/dev/null; then have_cache=1; fi
    now=$(date +%s)

    if [ -z "$have_cache" ] || [ $(( now - ${ts:-0} )) -ge "$PR_TTL" ]; then
      # Bump the timestamp first so concurrent refreshes don't pile up.
      { printf '%s %s\n' "$now" "$pr" > "$cache"; } 2>/dev/null
      (
        cd "$dir" 2>/dev/null || exit
        n=$(perl -e 'alarm 10; exec @ARGV' gh pr view --json number -q .number 2>/dev/null)
        case "$n" in ''|*[!0-9]*) n="" ;; esac
        printf '%s %s\n' "$(date +%s)" "$n" > "$cache"
      ) </dev/null >/dev/null 2>&1 &
    fi

    if [ -n "$pr" ]; then
      l2+=("${LAVENDER}#${pr}${RST}")
    else
      l2+=("${OVERLAY0}(no PR)${RST}")
    fi
  fi
else
  l2+=("${TEXT}${name}${RST}")
fi

[ ${#l2[@]} -gt 0 ] && join_segments "${l2[@]}"
exit 0
