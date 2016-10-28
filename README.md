# gitflow-made-easier
To make git flow works 'even easier'!

If you are a git flow user, you know how it could make your git related works easy: by taking care of the branch creation, merging, deletion stuffs for you. However, you may still feels time is being wasted on double-checking branch is created correctly, staging and committing changes manually. A typical work process using git flow is like:  
  
1. git flow feature start PROJ-1234  
2. git branch (make sure you're working on the newly created feature branch)  
3. make changes to source code (e.g. modify existing files, add new files, remove old files)  
4. git add newfile (stage the changes)  
5. git commit (commit staged changes)  
6. git log (make sure your latest changes are there)  
7. git status (make sure no missed changes)  
8. git flow feature finish PROJ-1234  
  
  
Now 'gitflow-made-easier' can give you a stronger hand, by condensing above tedious git flow process into just a couple commands:  
  
1. gitflow-made-easier.sh -t PROJ-1234 -g feature -s  
2. make changes to source code  
3. gitflow-made-easier.sh -t PROJ-1234 -g feature -f -c 'commit comment'  
