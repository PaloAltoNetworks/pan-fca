rm -f firewall_configured && python config-fw-v2.py $3
ansible-playbook create_sec_rule.yml --extra-vars "username=$1 password=$2 ip_address=$3"
