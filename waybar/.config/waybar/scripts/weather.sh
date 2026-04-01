#!/bin/bash

# Weather script for waybar using wttr.in
LOCATION="Valletta"
CACHE="/tmp/waybar-weather.json"
CACHE_AGE=1800  # 30 minutes

# Use cache if fresh enough
if [[ -f "$CACHE" ]]; then
    age=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
    if (( age < CACHE_AGE )); then
        cat "$CACHE"
        exit 0
    fi
fi

data=$(curl -sf "https://wttr.in/${LOCATION}?format=j1" 2>/dev/null)

if [[ -z "$data" ]]; then
    echo '{"text": " --°C", "tooltip": "Weather unavailable", "class": "clear"}'
    exit 0
fi

temp=$(echo "$data" | jq -r '.current_condition[0].temp_C')
feels=$(echo "$data" | jq -r '.current_condition[0].FeelsLikeC')
humidity=$(echo "$data" | jq -r '.current_condition[0].humidity')
desc=$(echo "$data" | jq -r '.current_condition[0].weatherDesc[0].value')
wind=$(echo "$data" | jq -r '.current_condition[0].windspeedKmph')

# Pick icon based on weather code
code=$(echo "$data" | jq -r '.current_condition[0].weatherCode')
case "$code" in
    113) icon="" ;;                          # Clear/Sunny
    116) icon="" ;;                          # Partly cloudy
    119|122) icon="" ;;                      # Cloudy/Overcast
    143|248|260) icon="" ;;                  # Fog/Mist
    176|263|266|293|296) icon="" ;;          # Light rain/drizzle
    299|302|305|308|356|359) icon="" ;;      # Heavy rain
    200|386|389|392|395) icon="" ;;          # Thunder
    179|182|185|227|230) icon="" ;;          # Snow/sleet
    311|314|317|320|323|326|329|332|335|338|350|368|371|374|377) icon="" ;; # Snow
    *) icon="" ;;
esac

# Build forecast tooltip
forecast=""
for i in 0 1 2; do
    day=$(echo "$data" | jq -r ".weather[$i].date")
    hi=$(echo "$data" | jq -r ".weather[$i].maxtempC")
    lo=$(echo "$data" | jq -r ".weather[$i].mintempC")
    d=$(echo "$data" | jq -r ".weather[$i].hourly[4].weatherDesc[0].value")
    forecast+="${day}  ${lo}°/${hi}°  ${d}\n"
done

tooltip="${desc} ${temp}°C\nFeels like ${feels}°C\nHumidity ${humidity}%  Wind ${wind} km/h\n\n${forecast}"

result=$(jq -nc \
    --arg text "$icon  ${temp}°C" \
    --arg tooltip "$tooltip" \
    --arg class "weather" \
    '{text: $text, tooltip: $tooltip, class: $class}')

echo "$result" > "$CACHE"
echo "$result"
