#!/bin/bash

echo '---';
echo 'fragments:';
find -path ./publish -prune -o -type f -iname '*.md' | \
    sed -s "s/^\.\///" | \
    sed -s "s/\.md$/.html/" | \
    sed -s "/^publish$/d" | \
    sed -s "s/^/  - \/fragments\//";
echo '...';
