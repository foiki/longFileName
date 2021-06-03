name="$1/a"
size=1
errCounter=0
lastSuccess=0
while [ $errCounter -le 3 ]
do
if (truncate --size=32K $name 2>/dev/null) 
then
errCounter=0
lastSuccess=$size
else 
((errCounter++))
fi
name="${name}a"
((size++))
done
echo "Maximum FileName length with Latin characters is: ${lastSuccess}"

name="$1/ж"
size=1
errCounter=0
lastSuccess=0
while [ $errCounter -le 3 ]
do
if (truncate --size=32K $name 2>/dev/null) 
then
errCounter=0
lastSuccess=$size
else 
((errCounter++))
fi
name="${name}ж"
((size++))
done
echo "Maximum FileName length with Cirillic characters is: ${lastSuccess}"

