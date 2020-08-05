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

echo '\n########################### Assetfinder Start ###########################\n'
assetfinder --subs-only $domain | tee $dir/asset_subs.txt
echo '\n########################### Assetfinder end ###########################\n'

#Sublister
echo '\n########################### Sublister start ###########################\n'
python3 ~/tools/Sublist3r/sublist3r.py -v -t 10 -d $domain -o $dir/subs.txt
echo '\n########################### Sublister end ###########################\n'

cat $dir/asset_subs.txt $dir/subs.txt | sort -u > $dir/subdomains.txt
rm $dir/asset_subs.txt
rm $dir/subs.txt

echo '\n########################### Total number of subdomains ###########################\n'
cat  $dir/subdomains.txt | wc -l

echo '\n########################### httprobe start ###########################\n'
cat $dir/subdomains.txt | httprobe | tee $dir/live_subdomains.txt
cat $dir/live_subdomains.txt | sort -u | tee $dir/live_subdomains.txt
echo '\n########################### httprobe end ###########################\n'
