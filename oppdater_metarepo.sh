meta init --force
while read -r project url
do
    meta project import "$project" "$url"
done < repos-speilvendt.txt

