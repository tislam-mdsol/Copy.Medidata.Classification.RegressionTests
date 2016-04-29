## Setting up Forked Repository

In order to push branches to forked repositories you need to edit the remote origin for your forked repository.  The ‘https://’ portion of the repository URL needs to be replaced with ‘git@github.com:’. 

The final remote URL should resemble: git@github.com:username/repo.git 

From Git Bash this can be accomplished using the following command: git remote set-url origin git@github.com:username/repo.git

In SourceTree this can be accomplished by following these steps:
 1. Right click on ‘Remotes'
 2. Click on ‘New Remote...'
 3. Select your existing ‘origin’ remote from the list
 4. Click the ‘Edit’ button
 5. Replace the ‘https://’ prefix with ‘git@github.com:'
 6. Click the ‘OK’ button

It is also a good idea to add an ‘upstream’ remote which refers back to the original repository.  This will make it easier for you to keep your forked repository up to date. 

## Contributing To Coder Backend

The backend of Coder is written in C#, using both [ASP.NET MVC](http://www.asp.net/mvc) and [ASP.NET](http://www.asp.net/).

To setup the development environment for the backend checkout [Coder backend setup](doc/coder_backend_setup.md).

## Contributing To Coder UI

Checkout the [contributing document](CoderWeb/StaticContent/coder_ui/CONTRIBUTING.md) for Coder UI.

