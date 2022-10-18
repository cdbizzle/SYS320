# Commands I will use for homework next week organized in dictionaries
blindFiles = [
    "cat /etc/resolv.conf",
    "cat /etc/motd",
    "cat /etc/issue",
    "cat ~/.bash_history",
]

system = ["uname -a", "ps aux", "top -n 1 -d", "id", "uname -m"]

networking = [
    "hostname -f",
    "ip addr show",
    "ip ro show",
    "route -n",
    "cat /etc/network/interfaces",
]

userAccounts = [
    "cat /etc/passwd",
    "cat /etc/shadow",
    "cat /etc/group",
    "getent passwd",  
    "getent group",
]

userInfo = [
    "ls -alh /home/*/",
    "ls -alh /home/*/.ssh/",
    "cat /home/*/.ssh/authorized_keys",
    "cat /home/*/.ssh/known_hosts",
    "cat /home/*/.hist",
]

configs = [
    "ls -aRl /etc/ * awk '$1 ~ /w.$/' * grep -v lrwx 2>/dev/nullte",
    "cat /etc/issue{,.net}",
    "cat /etc/master.passwd",
    "cat /etc/group",
    "cat /etc/hosts",
]

determineDistro = [
    "uname -a",
    "lsb_release -d",
    "/etc/os-release",
    "/etc/issue",
    "cat /etc/*release",
]

installedPackages = [
    "dpkg -l",
    "dpkg -l | grep -i 'linux-image'",
    "dpkg --get-selections",
    "cat /etc/apt/sources.list",
]

importantFiles = [
    "ls -dlR */",
    "ls -alR | grep ^d",
    "find /var -type d",
    "ls -dl `find /var -type d`",
    "ls -dl `find /var -type d` | grep -v root",
]