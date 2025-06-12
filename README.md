# haskell-profile

My personal website built with Haskell, Hakyll, and TailwindCSS.

## Deployment

```
# Verify correct branch
git checkout master

# Build new files
stack exec haskell-profile clean
stack exec haskell-profile build

# Commit
git add -A
git commit -m "Publish"

# Push
git push origin master:master
```
