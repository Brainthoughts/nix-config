if not test -z $SSH_AUTH_SOCK; and test -e $SSH_AUTH_SOCK
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
else
    set -Ux SSH_AUTH_SOCK $HOME"/.1password/agent.sock"
end
set -eg SSH_AUTH_SOCK
