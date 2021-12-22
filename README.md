# clone-gitlab-group
A shell script to clone all projects in a git group using gitlab V4 REST API

# Manual
Run the script and follow the assistant:

- install jq 
- replace variable GITLAB_DOMAIN with your gitlab domain like "https://gitlab.hughdai.com"
- set a environment variable GITLAB_SESSION like `21ab2d2c3cbc4dfc33cafb14084450bf` which stored in the browsers cookies as a value to key "_gitlab_session"
- chmod 777 clone_gitlab_group.sh
- vim ~/.bashrc
- alias clone ~/clone_gitlab_group.sh
- source ~/.bashrc
- clone `your gitlab group path like group/group_a/group_a0`
