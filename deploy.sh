rm -rf ./docs
hexo g
mv public docs
git add .
git commit -m 'Update'
# git pull
git push
