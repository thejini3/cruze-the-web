dir=$2
domain=$1

if [ -z "$1" ]; then
  echo "Domain requried! Ex: ./subdomains.sh example.com"
  exit 1
fi

if [ -z "$2" ]; then
  dir="."
fi

if [ "$dir" != "." ]; then
	mkdir -p $dir
fi

echo '-------------------Assetfinder start------------------------------------------'
assetfinder --subs-only $domain | tee $dir/asset_subs.txt

#Sublister
echo $'\n-------------------Sublister start------------------------------------------'
python3 ~/tools/Sublist3r/sublist3r.py -v -t 10 -d $domain -o $dir/subs.txt
echo $'-------------------Sublister end---------------------\n'

cat $dir/asset_subs.txt $dir/subs.txt | sort -u > $dir/subdomains.txt
rm $dir/asset_subs.txt
rm $dir/subs.txt

echo $'\nTotal number of subdomains\n'
cat  $dir/subdomains.txt | wc -l

echo $'\n-------------------httprobe start-------------------\n'
cat $dir/subdomains.txt | httprobe -c 50 -t 3000 > $dir/live_subdomains.txt
cat $dir/live_subdomains.txt | sort -u | tee $dir/live_subdomains.txt
echo $'-------------------httprobe end-------------------\n'