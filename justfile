set shell := ["bash", "-c"]

ANSIBLE_ENV := "ANSIBLE_CONFIG=ansible/ansible.cfg"

ping host="all" *ansible_args:
    set -euo pipefail
    {{ ANSIBLE_ENV }} ansible "{{ host }}" -m ping {{ ansible_args }}

tailscale command="status" host="all":
    set -euo pipefail
    if [ "{{ command }}" != "status" ]; then echo "Usage: just tailscale status [host]" >&2; exit 1; fi
    {{ ANSIBLE_ENV }} ansible-playbook -l "{{ host }}" ansible/playbooks/tailscale-status.yml

crictl subcommand="rmi" host="all":
    set -euo pipefail
    if [ "{{ subcommand }}" != "rmi" ]; then echo "Usage: just crictl rmi [host]" >&2; exit 1; fi
    {{ ANSIBLE_ENV }} ansible-playbook -l "{{ host }}" ansible/playbooks/crictl-rmi.yml
