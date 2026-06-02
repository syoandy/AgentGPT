#!/usr/bin/env bash
# empire-status.sh — Generate empire-wide status report on demand
# Per FEEP — produces a quarterly Empire Scalability Score snapshot
# Run from repo root: ./scripts/empire-status.sh

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

DATE="$(date '+%Y-%m-%d')"
OUT="docs/feep/audits/empire-status-${DATE}.md"
mkdir -p "$(dirname "$OUT")"

echo "Generating empire status report → $OUT"

{
  echo "# Empire Status Snapshot"
  echo "**Date:** $DATE"
  echo "**Generator:** scripts/empire-status.sh"
  echo "**Branch:** $(git rev-parse --abbrev-ref HEAD)"
  echo "**Commit:** $(git rev-parse HEAD)"
  echo ""
  echo "---"
  echo ""

  # 1. Doctrine coverage
  echo "## 1. Doctrine Coverage"
  echo ""
  echo "| Doctrine | Exists | Signed |"
  echo "|---|---|---|"
  for doc in \
    "docs/feep/00_FEEP_MASTER.md:FEEP Master" \
    "docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md:Universal Governance" \
    "docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md:Universal App Build" \
    "docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md:Universal Deployment" \
    "docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md:Universal Audit Matrix" \
    "docs/feep/05_CROSS_COMPANY_ISOLATION.md:Cross-Company Isolation" \
    "docs/feep/06_FUTURE_COMPANY_ONBOARDING.md:Future Onboarding" \
    "docs/feep/07_SCALABILITY_SCORE.md:Scalability Score" \
    "docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md:Founder Succession" \
    "docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md:Legal Fortress" \
    "docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md:Counselor Authority" \
    "docs/horizon-aba/MANDATORY_RULES.md:Mandatory Rules"; do
    path="${doc%%:*}"
    label="${doc##*:}"
    if [ -f "$path" ]; then
      exists="✅"
      # Signed = no unfilled signature placeholders
      if grep -q "Founder signature:.*____" "$path" 2>/dev/null \
         || grep -q "^Signature:.*____" "$path" 2>/dev/null \
         || grep -q "Signed:.*____" "$path" 2>/dev/null; then
        signed="❌"
      else
        signed="✅"
      fi
    else
      exists="❌"
      signed="—"
    fi
    echo "| $label | $exists | $signed |"
  done
  echo ""

  # 2. Entity coverage
  echo "## 2. Entity Coverage"
  echo ""
  echo "| Entity | Has docs/ folder | SESSION_LOG | Data Dictionary | Tier Assigned |"
  echo "|---|---|---|---|---|"
  for entity in horizon-aba poolcurrent; do
    folder="docs/${entity}"
    if [ -d "$folder" ]; then has_folder="✅"; else has_folder="❌"; fi

    log_path="${folder}/SESSION_LOG.md"
    if [ ! -f "$log_path" ]; then
      log_path="${folder}/operations/SESSION_LOG.md"
    fi
    if [ -f "$log_path" ]; then has_log="✅"; else has_log="❌"; fi

    dd_path="${folder}/legal/DATA_DICTIONARY.md"
    if [ ! -f "$dd_path" ]; then
      dd_path="${folder}/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md"
    fi
    if [ -f "$dd_path" ]; then
      if grep -q "\\[user/provider\\]\\|\\[Founder fills in\\]\\|TBD" "$dd_path" 2>/dev/null; then
        has_dd="⚠️ unfilled"
      else
        has_dd="✅"
      fi
    else
      has_dd="❌"
    fi

    tier_path="${folder}/security/TIER_ASSIGNMENT.md"
    if [ -f "$tier_path" ]; then
      if grep -q "\\[S / A / B / C\\]\\|TBD" "$tier_path" 2>/dev/null; then
        has_tier="⚠️ unassigned"
      else
        has_tier="✅"
      fi
    else
      has_tier="❌"
    fi

    echo "| ${entity} | ${has_folder} | ${has_log} | ${has_dd} | ${has_tier} |"
  done
  echo ""

  # 3. Open blockers (parse session logs for ⛔)
  echo "## 3. Open Blockers (from SESSION_LOG.md files)"
  echo ""
  for log in docs/horizon-aba/SESSION_LOG.md docs/poolcurrent/operations/SESSION_LOG.md; do
    if [ -f "$log" ]; then
      count=$(grep -c "⛔" "$log" 2>/dev/null || echo "0")
      echo "- ${log}: ${count} blocker entries"
    fi
  done
  echo ""

  # 4. Recent commits
  echo "## 4. Recent Activity (last 10 commits)"
  echo ""
  echo '```'
  git log --oneline -10
  echo '```'
  echo ""

  # 5. Scalability score (computed)
  echo "## 5. Computed Empire Scalability Score"
  echo ""

  # Doctrine coverage: count signed doctrines / total
  total_docs=12
  signed_count=0
  for doc in \
    "docs/feep/00_FEEP_MASTER.md" \
    "docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md" \
    "docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md" \
    "docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md" \
    "docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md" \
    "docs/feep/05_CROSS_COMPANY_ISOLATION.md" \
    "docs/feep/06_FUTURE_COMPANY_ONBOARDING.md" \
    "docs/feep/07_SCALABILITY_SCORE.md" \
    "docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md" \
    "docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md" \
    "docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md" \
    "docs/horizon-aba/MANDATORY_RULES.md"; do
    if [ -f "$doc" ]; then
      if ! grep -q "____" "$doc" 2>/dev/null; then
        signed_count=$((signed_count + 1))
      fi
    fi
  done
  exists_count=0
  for doc in \
    "docs/feep/00_FEEP_MASTER.md" \
    "docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md" \
    "docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md" \
    "docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md" \
    "docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md" \
    "docs/feep/05_CROSS_COMPANY_ISOLATION.md" \
    "docs/feep/06_FUTURE_COMPANY_ONBOARDING.md" \
    "docs/feep/07_SCALABILITY_SCORE.md" \
    "docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md" \
    "docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md" \
    "docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md" \
    "docs/horizon-aba/MANDATORY_RULES.md"; do
    if [ -f "$doc" ]; then
      exists_count=$((exists_count + 1))
    fi
  done
  doctrine_coverage=$(( (exists_count * 10 + signed_count * 10) / total_docs ))
  if [ "$doctrine_coverage" -gt 20 ]; then doctrine_coverage=20; fi

  echo "| Dimension | Score |"
  echo "|---|---|"
  echo "| 1. Doctrine Coverage | ${doctrine_coverage} / 20 |"
  echo "| 2. Automation Depth | (manual — Counselor sets) |"
  echo "| 3. Counselor Independence | (manual — depends on designation + activity) |"
  echo "| 4. Entity Isolation | (manual — depends on audit) |"
  echo "| 5. Truth Score Discipline | (manual — depends on deploy history) |"
  echo ""
  echo "Doctrines existing: ${exists_count} / ${total_docs}"
  echo "Doctrines signed: ${signed_count} / ${total_docs}"
  echo ""
  echo "Full score methodology in docs/feep/07_SCALABILITY_SCORE.md"
  echo ""

  # 6. Next milestones
  echo "## 6. Next Milestones (from Founder Action Sheet)"
  echo ""
  if [ -f "docs/horizon-aba/FOUNDER_ACTION_SHEET.md" ]; then
    grep -E "^## ⏱ ACTION" docs/horizon-aba/FOUNDER_ACTION_SHEET.md || echo "No action items found"
  fi

  echo ""
  echo "---"
  echo "*Generated by scripts/empire-status.sh*"
} > "$OUT"

echo "Done. Report at: $OUT"
echo ""
echo "Summary:"
echo "  Doctrines existing: ${exists_count} / ${total_docs}"
echo "  Doctrines signed:   ${signed_count} / ${total_docs}"
echo "  Doctrine coverage:  ${doctrine_coverage} / 20"
