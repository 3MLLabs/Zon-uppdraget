#!/usr/bin/env bash
fil="${1:-testfall-jump.csv}"
ut="${2:-resultat.csv}"
echo "id,forvantat,faktiskt,ms,avvikelse" > "$ut"
ok=0; fel=0
while IFS=, read -r id kalla dest port proto riktn forv _; do
  [ "$id" = "id" ] && continue
  port="${port//$'\r'/}"
  start=$(date +%s%N)
  timeout 3 bash -c "exec 3<>/dev/tcp/$dest/$port" 2>/dev/null
  rc=$?
  ms=$(( ($(date +%s%N) - start) / 1000000 ))
  if [ $rc -eq 0 ]; then utfall=oppen
  elif [ $rc -eq 124 ]; then utfall=tyst
  else utfall=avvisad; fi
  if [ "$utfall" = "$forv" ]; then avv=""; ok=$((ok+1)); else avv="AVVIKELSE"; fel=$((fel+1)); fi
  echo "$id,$forv,$utfall,$ms,$avv" | tee -a "$ut"
done < "$fil"
echo "Sammanfattning: $((ok+fel)) testfall, $ok stämmer, $fel avviker"
