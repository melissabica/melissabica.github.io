#!/usr/bin/env bash
#
# Publish the www.melissabica.com website.
#
# Usage:
#   ./update-site.sh "commit message"                 # stage & commit all changes
#   ./update-site.sh "commit message" file1 file2 ... # stage & commit only these files
#
# The script:
#   1. builds the site locally with Jekyll (catches broken Markdown/YAML),
#   2. stages your changes,
#   3. commits with the given message,
#   4. pushes to master, which triggers the GitHub Pages build.
#
# Build/deploy status: https://github.com/melissabica/melissabica.github.io/deployments

set -euo pipefail

usage() {
  echo "Usage: ./update-site.sh \"commit message\" [file ...]" >&2
  echo "  With no files listed, all changes are staged (git add -A)." >&2
  exit 2
}

[ $# -ge 1 ] || usage
MSG="$1"
shift

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

# 1. Build check ------------------------------------------------------------
if command -v jekyll >/dev/null 2>&1; then
  echo "==> Checking that the site builds locally..."
  if ! jekyll build --destination /tmp/melissabica-site-check > /tmp/melissabica-build.log 2>&1; then
    echo "!! Local build FAILED - nothing was committed." >&2
    echo "   See /tmp/melissabica-build.log (last lines below):" >&2
    tail -30 /tmp/melissabica-build.log >&2
    exit 1
  fi
  echo "    Build OK"
else
  echo "==> jekyll not found; skipping local build check."
fi

# 2. Stage ------------------------------------------------------------------
if [ $# -gt 0 ]; then
  git add -- "$@"
else
  git add -A
fi

# 3. Commit -----------------------------------------------------------------
if git diff --cached --quiet; then
  echo "==> Nothing staged - no commit to make."
  exit 0
fi
git status --short
git commit -m "$MSG"

# 4. Push -------------------------------------------------------------------
git push origin master

echo ""
echo "==> Pushed to master. GitHub Pages is rebuilding (usually 1-2 minutes)."
echo "    Status: https://github.com/melissabica/melissabica.github.io/deployments"
echo "    Live:   https://www.melissabica.com"
