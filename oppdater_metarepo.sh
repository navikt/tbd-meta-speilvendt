meta init --force
while read -r project url
do
    meta project import "$project" "git@github.com:navikt/$project".git
done < repos.txt

# Fjern duplikater fra .gitignore
echo "$(sort -u .gitignore | cat -n | sort -nk1 | cut -f2-)" > .gitignore