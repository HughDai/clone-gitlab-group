#!/bin/sh -i

# ====================================================================
# @author hughdai1988@gmail.com
# Clone all projects in a git group using gitlab V4 REST API.
# dependencies: jq
# ====================================================================

# ====================================================================
# manual
# Set a environment variable GITLAB_SESSION like "21ab2d2c3cbc4dfc33cafb14084450bf" which stored in the browsers cookies as a value to key "_gitlab_session"
# chmod 777 clone_gitlab_group.sh
# vim ~/.bashrc
# alias clone ~/clone_gitlab_group.sh
# source ~/.bashrc
# clone group/group_a/group_a0
# ====================================================================

GITLAB_DOMAIN="your gitlab domain"
GITLAB_SSH_REPO_KEY="ssh_url_to_repo"
GITLAB_PATH_KEY="full_path"
GITLAB_SESSION_KEY="_gitlab_session"

if ! [ -x "$(command -v jq)" ]; then
  echo "\033[31;1m Please install jq first \033[0m"
  exit 1;
fi

if [ -z "$1" ]; then
  echo "\033[31;1m Gitlab group path is required \033[0m"
  exit 1;
fi

GITLAB_GROUP_PATH="$1"

if [ -z "$GITLAB_SESSION" ]; then
  echo "\033[31;1m Please set the environment variable GITLAB_SESSION \033[0m"
  exit 1;
fi

echo "\033[40;38;5;82m ************** Clone all projects in $GITLAB_GROUP_PATH BEGIN ************** \033[0m"

GROUPS_API_URI="$GITLAB_DOMAIN/api/v4/groups?per_page=999"

GROUP_ID=$(curl -s $GROUPS_API_URI -H "Cookie: $GITLAB_SESSION_KEY=$GITLAB_SESSION" | jq ".[] | select (.$GITLAB_PATH_KEY == \"$GITLAB_GROUP_PATH\") | .id")

if [ -z "$GROUP_ID" ]; then
  echo "\033[31;1m Gitlab session expired OR Can not find git group $GITLAB_GROUP_PATH \033[0m"
  exit 1;
fi

PROJECTS_API_URI="$GITLAB_DOMAIN/api/v4/groups/$GROUP_ID/projects?per_page=999"

PROJECTS=$(curl -s $PROJECTS_API_URI -H "Cookie: $GITLAB_SESSION_KEY=$GITLAB_SESSION" | jq)

PRJ_LEN=`echo $PROJECTS | jq 'length'`

for index in `seq 1 $PRJ_LEN`; do
  THEPATH=`echo $PROJECTS | jq .[$index-1].path | sed 's/\"//g'`
  REPO=`echo $PROJECTS | jq .[$index-1].$GITLAB_SSH_REPO_KEY | sed 's/\"//g'`
  if [ ! -d "$THEPATH" ]; then
    echo "\033[32;1m Cloning $THEPATH ($REPO) \033[0m"
    git clone $REPO --quiet & 
  else
    echo "\033[32;1m Pulling $THEPATH \033[0m"
    (cd "$THEPATH" && git pull --quiet) &
  fi
done

echo "\033[40;38;5;82m ************** Clone all projects in $GITLAB_GROUP_PATH END ************** \033[0m"

exit 1;
  
