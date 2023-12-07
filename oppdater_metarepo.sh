meta init --force
while read -r project
do
    project import "$project" git@github.com:navikt/$project.git
done < repos.txt
