repo=$1
if [ -z $repo ] || [ ! -d $repo ]
then
  echo "First parameter must be a path to a git repository"
  exit 1
fi
rm $repo/.git/hooks/beams-commit-message-checker-hook
