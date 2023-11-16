#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

github_team="tbd"
role_name="admin" # admin write read

github_team_id=$(gh api "/orgs/navikt/teams/$github_team" | jq '.id')
gh api "/teams/$github_team_id/repos" --paginate > repos.json

get_repos() {
    local team=$1
    local role_name=$2

    jq 'map(select(.archived == false))' repos.json \
    | jq  --arg role_name "$role_name" -c 'map(select(.role_name == $role_name))' \
    | jq  --arg  team "$team" 'map(select(any(.topics[]; tostring | contains($team))))' \
    | jq  -r '.[] | "\(.name) \(.ssh_url)"' \
    | sort
}


subteams=("speilvendt" "spleiselaget" "bomlo" "styringsinfobros")

for team in ${subteams[@]}; do
    echo $team;
    get_repos $team $role_name > repos-$team.txt
done


roles=("admin" "write" "read")

for role in ${roles[@]}; do
    jq 'map(select(.archived == false))' repos.json | jq  --arg role_name "$role" -c 'map(select(.role_name == $role_name))' | jq -r '.[] | "\(.name) \(.ssh_url)"' | sort > all-$role.txt;
    grep -F -x -v \
        -f \
            repos-${subteams[0]}.txt \
            repos-${subteams[1]}.txt \
            repos-${subteams[2]}.txt \
            repos-${subteams[3]}.txt \
        all-$role.txt > repos-eierløs-$role.txt;
    rm all-$role.txt;
done

rm repos.json
