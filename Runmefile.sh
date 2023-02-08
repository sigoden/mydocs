#!/usr/bin/env bash

set -e

# @cmd Generate SUMMARY.md/README.md
gen() {
    echo > src/README.md
    echo "[Projects](./README.md)" > src/SUMMARY.md
    for f in src/*.md; do
        filename=$(basename $f)
        if [[ "$filename" == README.md ]] || [[ "$filename" == SUMMARY.md ]]; then
            continue
        fi
        first_line=$(cat $f | head -1 | sed 's/^# //')
        first_part="${first_line%%:*}"
        second_part="${first_line#*:}"
        echo "* [$first_part](./$filename):$second_part" >> src/README.md
        echo "* [$first_part](./$filename)" >> src/SUMMARY.md
    done
}

# @cmd Run book
run() {
    mdbook serve
}


# @cmd Build book
build() {
    gen
    mdbook build
}

eval $(runme --runme-eval "$0" "$@")
