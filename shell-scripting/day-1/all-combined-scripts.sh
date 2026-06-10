#!/bin/bash

count=$(ls "$1" | wc -l)
echo "Total files: $count"

Run:

./countfiles.sh /etc
Here:

$1 = /etc (first argument)

$2 = second argument

$# = total number of arguments

$@ = all arguments

$0 = script name itself

#!/bin/bash

echo "Counting files in: $1"

count=$(ls "$1" | wc -l)

echo "Total files: $count"

If you run:

./countfiles.sh /etc
Output:

Counting files in: /etc
Total files: 235

 Bash, how might you check if an argument was actually provided before you try to count the files?

Use an if check with -z to see if $1 is empty:

#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please provide a directory name."
    echo "Usage: $0 <directory>"
    exit 1
fi

echo "Counting files in: $1"

count=$(ls "$1" | wc -l)

echo "Total files: $count"
Meaning:

[ -z "$1" ]
checks: is $1 empty?

So if you run only:

./countfiles.sh
It will show the error instead of breaking.


Complete Script
#!/bin/bash

usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Current disk usage: ${usage}%"

if [ "$usage" -gt 80 ]; then
    echo "Warning: Disk space is running low!"
else
    echo "Disk space is healthy."
fi
Example outputs:

Current disk usage: 91%
Warning: Disk space is running low!
or

Current disk usage: 45%
Disk space is healthy.
For an interview, be able to explain:

df -h / → Shows disk usage of /

awk 'NR==2 {print $5}' → Prints the 5th column from the second line

tr -d '%' → Removes %

-gt → Greater than comparison for integers

$usage → Variable holding disk usage percentage


#!/bin/bash

usage=$(free -m | awk 'NR==2 {print $3}')

echo "Current RAM usage: ${usage}MiB"

if [ "$usage" -gt 4096 ]; then
    echo "Warning: RAM usage is high!"
else
    echo "RAM usage is healthy."
fi



if you wanted to write a script that loops through all files in a directory and checks if they are empty (using the -s flag, which checks if a file has a size greater than zero), how would you structure that for loop?

You would typically use a for loop like this:

#!/bin/bash

for file in *; do
    if [ -f "$file" ]; then
        if [ -s "$file" ]; then
            echo "$file is not empty."
        else
            echo "$file is empty."
        fi
    fi
done

Think like this:

-s = size exists
Common file checks:

-f file   # regular file
-d dir    # directory
-e file   # exists
-r file   # readable
-w file   # writable
-x file   # executable
-s file   # size greater than zero


#!/bin/bash

# Use the first argument if provided, otherwise default to /var/log
DIR="${1:-/var/log}"

for file in "$DIR"/*; do
    # Check if it is a file AND if it is empty
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        echo "$(basename "$file") : Empty"
    
    # Check if it is a file AND if it is NOT empty
    elif [ -f "$file" ] && [ -s "$file" ]; then
        echo "$(basename "$file") : Not Empty"
    fi
done
explain every line 


If you had a list of IP addresses in a file named servers.txt, and you wanted to loop through them to check if they are "up" using the ping command, how would you structure a while loop to read that file and run ping -c 1 on each IP?

You would use a while read loop:

#!/bin/bash

while read -r ip; do
    if ping -c 1 "$ip" > /dev/null 2>&1; then
        echo "$ip is UP"
    else
        echo "$ip is DOWN"
    fi
done < servers.txt


If we look back at your "Disk Space Monitor" script from earlier, how would you structure a function named check_disk() that contains the logic to print the usage and alert the user?

You can put the same logic inside a function like this:

#!/bin/bash

check_disk() {
    usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Current disk usage: ${usage}%"

    if [ "$usage" -gt 80 ]; then
        echo "Warning: Disk space is running low!"
    else
        echo "Disk space is healthy."
    fi
}

check_disk
Important part:

check_disk() {
    # commands go here
}
And this line runs the function:

check_disk


Full working version:

#!/bin/bash

check_disk() {
    local partition=$1

    usage=$(df -h "$partition" | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Usage for $partition: ${usage}%"

    if [ "$usage" -gt 80 ]; then
        echo "Warning: Disk space is running low!"
    else
        echo "Disk space is healthy."
    fi
}

check_disk "/"
check_disk "/home"




I want you to write a script that defines three functions:

check_disk(): (Use the logic we just built).

check_memory(): (Hint: use free -m and awk to find the percentage of used memory).

check_uptime(): (Hint: use the uptime -p command).

Use this script:

#!/bin/bash

check_disk() {
    local partition="/"
    local usage

    usage=$(df -h "$partition" | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Disk usage for $partition: ${usage}%"

    if [ "$usage" -gt 80 ]; then
        echo "Warning: Disk space is running low!"
    else
        echo "Disk space is healthy."
    fi
}

check_memory() {
    local memory_usage

    memory_usage=$(free -m | awk 'NR==2 {printf "%.0f", $3/$2 * 100}')

    echo "Memory usage: ${memory_usage}%"

    if [ "$memory_usage" -gt 80 ]; then
        echo "Warning: Memory usage is high!"
    else
        echo "Memory is healthy."
    fi
}

check_uptime() {
    local system_uptime

    system_uptime=$(uptime -p)

    echo "System uptime: $system_uptime"
}

check_disk
check_memory
check_uptime
