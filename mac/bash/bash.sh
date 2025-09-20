alias remote="git remote -v | head -n 1 | cut -d '@' -f 2 | cut -d ' ' -f 1 | sed 's/:/\//' | sed 's/.git//' | sed 's/^/http:\/\//' | xargs open"
alias remoteUrl="git remote -v | head -n 1 | cut -d '@' -f 2 | cut -d ' ' -f 1 | sed 's/:/\//' | sed 's/.git//' | sed 's/^/http:\/\//'"


function openPullRequestNumber() {
    gh pr list  | grep $(git branch --show-current) | grep -i -o "^[0-9]*"
}


function pr() {
    open `remoteUrl`/pull/`openPullRequestNumber`
}

function prc() {
    open `remoteUrl`/pull/`openPullRequestNumber`/checks
}

function action() {
    open `remoteUrl`/actions?query=branch:`git branch --show-current`
}

