domain=$1
dir=$2

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

assetFinder(){
  # assetfinder
  echo 	"\e[91m-------------------Assetfinder Started  -------------------------------------------\e[0m"
  assetfinder --subs-only $domain | tee $dir/asset_subs.txt
}

subLister(){
  # sublister
  echo 	"\e[91m-------------------Sublister Started  ----------------------------------------------\e[0m"
  python3 ~/tools/Sublist3r/sublist3r.py -t 10 -d $domain -o $dir/subs.txt
}

subFinder(){
  # subfinder
  echo 	"\e[91m-------------------Subfinder---------------------------------------------------------\e[0m"
  subfinder -d $domain --silent -o $dir/subfinder.txt
}

rapiddns(){
  echo 	"\e[91m-------------------Rapiddns-----------------------------------------------------------\e[0m"
  curl -s "https://rapiddns.io/subdomain/$domain?full=1"| grep -oP '_blank">\K[^<]*' | grep -v http | sort -u | tee $dir/rapiddns.txt
}

groupSubdomains(){
  cat $dir/asset_subs.txt $dir/subs.txt $dir/subfinder.txt $dir/rapiddns.txt | sort -u > $dir/subdomains.txt
  rm $dir/asset_subs.txt
  rm $dir/subs.txt
  rm $dir/subfinder.txt
  rm $dir/rapiddns.txt
}

liveSubdomains(){
  echo 	"\e[91m-------------------httprobe-----------------------------------------------------------\e[0m"
  cat $dir/subdomains.txt | httprobe | tee $dir/live_subdomains.txt
}

# subdomain hunt 
assetFinder
subLister
subFinder
rapiddns
groupSubdomains
liveSubdomains