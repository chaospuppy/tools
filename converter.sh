#!/bin/bash

# converter.sh
# This script converts batch (.bat) files to shell files (.sh)

DIR=$1

shopt -s nullglob
for f in $DIR/*.bat
do
    echo "Processing $f file..."
    
    cp -- "$f" "${f%.bat}.sh"

    s="${f%.bat}.sh"
    echo $s
   
    dos2unix $s 

    FIRST_LINE=$(head -1 $s)  
    
    if [ "$FIRST_LINE" != "#!/bin/bash" ]
    then
        sed -i "1s/^/#!\/bin\/bash\n/" $s
    fi 
    
    sed -i "s/xcopy/cp/g" $s
    sed -i "s/copy/cp/g" $s
    sed -i "s/move/mv/g" $s
    sed -i "s/MOVE/mv/g" $s
    sed -i "s/ECHO/echo/" $s
    sed -i "s/@echo/echo/gI" $s
    sed -i "s/REM/#/" $s
    sed -i "s/call/source/" $s
    sed -i "s/set /export /" $s
    sed -i "s/ \// -/g" $s
    sed -i "s/\\\/\//g" $s
    sed -i "s/%\([a-zA-Z_]\+\)%/\$\1/g" $s
    sed -i "s/\.bat/\.sh/" $s
    sed -i "s/\:end//g" $s
    sed -i "s/\:END//g" $s
    sed -i "s/goto END//g" $s
    sed -i "s/END//g" $s
    sed -i "s/\:\([A-Za-z_]\+\)/\1 \(\){/g" $s
    sed -i "s/goto end/exit 0/g" $s
    sed -i "s/ @/ /g" $s
    sed -i "s/goto \([a-zA-Z_]\+\)/\1/g" $s    
    sed -i "s/if not ERRORLEVEL \([0-9]\)/if [ \$\?!=\1 ] /g" $s
    sed -i "s/if not defined \([A-Za-z_]\+\)\s\+\([A-Za-z_]\+\)/if [[ -n '\1' ]] \n then \2 \nfi/g" $s 

done

exit 0
