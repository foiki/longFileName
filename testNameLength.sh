name="$1/a"
size=0
while truncate --size=16K $name 2>/dev/null
do
name="${name}a"
size=$((size+1))
done
echo "Maximum FileName length with Latin characters is: ${size}"

name="$1/ж"
size=0
while truncate --size=16K $name 2>/dev/null
do
name="${name}ж"
size=$((size+1))
done
echo "Maximum FileName length with Cyrillic characters is: ${size}"
