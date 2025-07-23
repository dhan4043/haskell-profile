# haskell-profile

My personal website built with Haskell, Hakyll, and TailwindCSS. Based on [this](https://ldgrp.me/) website.

## Deployment

```
# Verify correct branch
git checkout master

# Compile stylesheet (if any changes were made) 
npx @tailwindcss/cli -i ./css/input.css -o ./css/output.css

# Build new files
stack exec haskell-profile clean
stack exec haskell-profile build

# Commit
git add -A
git commit -m "Publish"

# Push
git push origin master:master
```
