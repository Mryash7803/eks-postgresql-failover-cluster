#!/bin/bash

#!/bin/bash

for file in *; do
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            echo "$file is excecutable."
        else
            echo "$file is not excecutable."
        fi
    fi
done
