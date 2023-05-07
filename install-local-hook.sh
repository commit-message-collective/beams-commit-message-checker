docker pull ghcr.io/commit-message-collective/beams-commit-message-checker:latest
repo=$1
if [ -z $repo ] || [ ! -d $repo ]
then
  echo "First parameter must be a path to a git repository"
  exit 1
fi

target=$repo/.git/hooks/commit-msg
if [ -e $target ]
then
  if [ ! -e $repo/.git/hooks/commit-msg.bac ]
  then
    # TODO: call existing commit-msg hook instead of replacing it
    echo "Backing up existing commit hook to $repo/.git/hooks/commit-msg.bac"
    mv $target $repo/.git/hooks/commit-msg.bac
  fi
fi
mkdir -p $repo/.git/hooks
cp commit-msg-hook.sh $target
chmod +x $target
echo "Installed commit hook to $target"
