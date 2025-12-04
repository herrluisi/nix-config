#!/usr/bin/env bash

powersave="powerprofilesctl set power-saver"
balanced="powerprofilesctl set balanced"
performance="powerprofilesctl set performance"

get_status() {
  current="$(powerprofilesctl get)"
  percentage=0
  class=""
  if [ "$current" = "power-saver" ]; then
    percentage=10
    class="powersave"
  elif [ "$current" = "balanced" ]; then
    percentage=30
    class="balanced"
  else
    percentage=50
    class="performance"
  fi
}

case "$1" in
  "powersave")
    $powersave
    ;;
  "balanced")
    $balanced
    ;;
  "performance")
    $performance
    ;;
  "get")
    get_status
    echo "{\"text\": \"${current}\", \"tooltip\": \"${current} mode\", \"class\": \"${class}\", \"percentage\": ${percentage}}"
    ;;
  "")
    get_status
    if [ "$current" = "power-saver" ]; then
      $balanced
    elif [ "$current" = "balanced" ]; then
      $performance
    else
      $powersave
    fi
    ;;
  *)
    echo "Usage: $0 {powersave|balanced|performance|get}"
    exit 1
    ;;
esac
