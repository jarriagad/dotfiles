#!/bin/bash


# Use this to sync scripts before committing changes

target_folder=""
while IFS= read -r line; do
  if [[ $line == \[*\] ]]; then
    target_folder=$(echo "$line" | tr -d '[]')
    mkdir -p "./$target_folder"
  elif [[ ! -z "$target_folder" && -f "$line" ]]; then
    cp "$line" "./$target_folder/"
  fi
done < ".env"

