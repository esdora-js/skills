#!/usr/bin/env bash
# Safety tests for git-commit-batcher skill procedures.
# Each scenario builds a real repo in a temp dir and asserts the git behavior
# the skill's workflows rely on.
set -u
PASS=0; FAIL=0
ok() { # name actual expected
  if [ "$2" = "$3" ]; then PASS=$((PASS+1)); echo "PASS  $1";
  else FAIL=$((FAIL+1)); echo "FAIL  $1"; echo "  expected: $(printf %s "$3" | head -3)"; echo "  actual:   $(printf %s "$2" | head -3)"; fi
}
okcond() { # name rc — 0 means condition held
  if [ "$2" -eq 0 ]; then PASS=$((PASS+1)); echo "PASS  $1"; else FAIL=$((FAIL+1)); echo "FAIL  $1"; fi
}

ROOT=$(mktemp -d /tmp/commit-batcher-test.XXXXXX)
trap 'rm -rf "$ROOT"' EXIT
new_repo() {
  mkdir -p "$ROOT/$1"; cd "$ROOT/$1" || exit 1
  git -c init.defaultBranch=main init -q
  git config user.email t@t; git config user.name t; git config commit.gpgsign false
  D="$(git rev-parse --git-dir)/commit-batcher"; mkdir -p "$D"
}

echo "== S1/S2: fully-staged 保持暂存 restore fidelity =="
new_repo s1
echo v1 > a.txt; git add a.txt; git commit -qm init
echo v2 > a.txt; git add a.txt                              # user stages v2
git diff --cached --binary -- a.txt > "$D/a.patch"
ORIG=$(git diff --cached -- a.txt)
git restore --staged a.txt                                  # move out of index
echo b > b.txt; git add b.txt; git commit -qm "feat: b"     # other batch commits
echo v3 > a.txt                                             # hook/IDE drift mid-run
git apply --cached "$D/a.patch"
ok "S1 patch restore == originally staged diff" "$(git diff --cached -- a.txt)" "$ORIG"
ok "S1 worktree content untouched by restore" "$(cat a.txt)" "v3"
git restore --staged a.txt
git add a.txt                                               # OLD pre-fix restore path
OLD_RESTORE=$(git diff --cached -- a.txt)
[ "$OLD_RESTORE" != "$ORIG" ]; rc=$?
okcond "S2 old git-add restore silently stages drifted content (hazard confirmed)" $rc

echo "== S3: partially staged file patch round-trip =="
new_repo s3
seq 1 12 > f.txt; git add f.txt; git commit -qm init
{ echo 1; echo 2S; seq 3 12; } > f.txt; git add f.txt       # staged hunk S (line 2)
{ echo 1; echo 2S; seq 3 10; echo 11U; echo 12; } > f.txt   # unstaged hunk U (line 11)
git diff --cached --binary -- f.txt > "$D/f.patch"
S_BEFORE=$(git diff --cached -- f.txt)
git restore --staged f.txt
echo g > g.txt; git add g.txt; git commit -qm "feat: g"     # other batch commits
git apply --cached "$D/f.patch"
ok "S3 staged hunks restored exactly" "$(git diff --cached -- f.txt)" "$S_BEFORE"
U=$(git diff -- f.txt)
echo "$U" | grep -q '^+11U$'; rc1=$?
echo "$U" | grep -q '^+2S$'; rc2=$?
[ $rc1 -eq 0 ] && [ $rc2 -ne 0 ]; rc=$?
okcond "S3 unstaged hunk stays in worktree, not in index" $rc

echo "== S4: git apply --cached is atomic on failure =="
new_repo s4
seq 1 5 > f.txt; git add f.txt; git commit -qm init
{ echo 1; echo 2S; seq 3 5; } > f.txt; git add f.txt
git diff --cached --binary -- f.txt > "$D/f.patch"
git restore --staged f.txt
{ echo 1; echo 2X; seq 3 5; } > f.txt; git add f.txt; git commit -qm "fix: same lines"
git apply --cached "$D/f.patch" 2>/dev/null; rc=$?
[ $rc -ne 0 ]; okcond "S4 stale patch rejected with nonzero exit" $?
ok "S4 index unchanged after failed apply" "$(git diff --cached)" ""

echo "== S5: binary staged content =="
new_repo s5
printf 'A\0B\0C' > bin.dat; git add bin.dat; git commit -qm init
printf 'A\0B\0C\0D\0E' > bin.dat; git add bin.dat
N=$(git diff --cached --numstat -- bin.dat | cut -f1)
ok "S5 numstat flags binary as '-'" "$N" "-"
git diff --cached --binary -- bin.dat > "$D/bin.patch"
grep -q '^literal' "$D/bin.patch"; rc=$?
okcond "S5 --binary patch carries literal data" $rc
git restore --staged bin.dat
git apply --cached "$D/bin.patch" 2>/dev/null; rc=$?
okcond "S5 binary patch applies to index" $rc
ok "S5 staged blob == worktree blob" "$(git ls-files -s bin.dat | awk '{print $2}')" "$(git hash-object bin.dat)"

echo "== S6: in-progress merge/rebase detection =="
new_repo s6
echo base > f.txt; git add f.txt; git commit -qm base
git checkout -qb feature; echo feat > f.txt; git commit -qam feat
git checkout -q main; echo main > f.txt; git commit -qam main
git checkout -q feature
git rebase main >/dev/null 2>&1; rc=$?
[ $rc -ne 0 ]; okcond "S6 rebase stops on conflict" $?
[ -d "$(git rev-parse --git-path rebase-merge)" ]; rc=$?
okcond "S6 rebase-merge dir detected (skill's test -d)" $rc
if [ -f "$(git rev-parse --git-path REBASE_HEAD)" ]; then
  echo "INFO  S6 REBASE_HEAD present in this state"
else
  echo "INFO  S6 REBASE_HEAD ABSENT mid-rebase (proves REBASE_HEAD check unreliable)"
fi
git rebase --abort
git checkout -q main
git merge feature >/dev/null 2>&1; rc=$?
[ $rc -ne 0 ]; okcond "S6 merge stops on conflict" $?
[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]; rc=$?
okcond "S6 MERGE_HEAD detected (skill's test -f)" $rc
git merge --abort

echo "== S7/S8: whole-index commit sweep & -F message fidelity =="
new_repo s7
git commit -q --allow-empty -m init
echo x > x.txt; echo y > y.txt; git add -- x.txt y.txt      # y is NOT in the batch
printf 'feat(core): 添加功能\n\n- 第一行\n- 第二行\n' > "$D/msg"
git commit -qF "$D/msg"
FILES=$(git show --name-only --format= HEAD | grep -c '\.txt$')
ok "S7 commit sweeps entire index incl. out-of-batch y (why index==batch matters)" "$FILES" "2"
ok "S8 multi-line zh message preserved exactly via -F" "$(git log -1 --format=%B)" "$(cat "$D/msg")"

echo
echo "RESULT: $PASS passed, $FAIL failed"
[ $FAIL -eq 0 ]
