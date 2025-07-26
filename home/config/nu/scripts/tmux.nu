# tmux

alias t = tmux

alias "t l" = tmux list-sessions
alias "t k" = tmux kill-server
alias "tmux k" = tmux kill-server

def "t cc" [name?: string] {
  tmux cc $name
}
def "tmux cc" [name?: string] {
    let session_name = if ($name | is-empty) {
        $"(pwd | path basename)/(random uuid | str substring 0..8)"
    } else {
        $"(pwd | path basename)/($name)"
    }

    tmux new-session -d -s $session_name claude
    tmux attach-session -t $session_name
}

def "t n" [name?: string] {
  tmux n $name
}
def "tmux n" [name?: string] {
    let session_name = if ($name | is-empty) {
        $"(pwd | path basename)/(random uuid | str substring 0..8)"
    } else {
        $"(pwd | path basename)/($name)"
    }
    tmux new-session -d -s $session_name
    tmux attach-session -t $session_name
}

def "t a" [] {
  tmux a
}
def "tmux a" [] {
    let sessions = (tmux list-sessions -F "#{session_name}" | complete)
    if $sessions.exit_code != 0 {
        print "No sessions"
        return
    }
    let selected = ($sessions.stdout | lines | to text | fzf)
    if ($selected | is-empty) {
        return
    }
    tmux attach-session -t $selected
}
