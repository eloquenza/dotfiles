#!/bin/sh

. ~/.secrets/openweathermap_secrets

get_icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

    echo $icon
}

get_duration() {

    osname=$(uname -s)

    case $osname in
        *BSD) date -r "$1" -u +%H:%M;;
        *) date --date="@$1" -u +%H:%M;;
    esac

}

UNITS="metric"
SYMBOL="°"

if [ ! -z $OPENWEATHERMAP_CITY ]; then
    current=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$OPENWEATHERMAP_KEY&id=$OPENWEATHERMAP_CITY&units=$UNITS")
    forecast=$(curl -sf "http://api.openweathermap.org/data/2.5/forecast?APPID=$OPENWEATHERMAP_KEY&id=$OPENWEATHERMAP_CITY&units=$UNITS&cnt=1")
else
    location=$(curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ ! -z "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?appid=$OPENWEATHERMAP_KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        forecast=$(curl -sf "http://api.openweathermap.org/data/2.5/forecast?APPID=$OPENWEATHERMAP_KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=1")
    fi
fi

if [ ! -z "$current" ] && [ ! -z "$forecast" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")

    forecast_temp=$(echo "$forecast" | jq ".list[].main.temp" | cut -d "." -f 1)
    forecast_icon=$(echo "$forecast" | jq -r ".list[].weather[0].icon")


    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend=""
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend=""
    else
        trend=""
    fi


    sun_rise=$(echo "$current" | jq ".sys.sunrise")
    sun_set=$(echo "$current" | jq ".sys.sunset")
    now=$(date +%s)

    if [ "$sun_rise" -gt "$now" ]; then
        daytime=" $(get_duration "$((sun_rise-now))")"
    elif [ "$sun_set" -gt "$now" ]; then
        daytime=" $(get_duration "$((sun_set-now))")"
    else
        daytime=" $(get_duration "$((sun_rise-now))")"
    fi

    echo "%{T3}$(get_icon "$current_icon") %{T-}$current_temp$SYMBOL %{T3}$trend $(get_icon "$forecast_icon") %{T-}$forecast_temp$SYMBOL"
fi
