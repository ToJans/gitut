# Gitut

This tool allows you to turn *any* git repository as a tutorial, given it has proper commit messages. 

This is currently still a WIP, but I think it works rather well.

## Getting started

### Install `gitut`

Make sure you have `elixir` and `git` installed and available in your path; then build the `gitut` tool

```dos
git clone https://github.com/ToJans/gitut.git
cd gitut
mix compile
```

And make sure the `bin\gitut.bat` is available in your path.

### Test `gitut`

Go to a folder where you want to test it; here is an example:

```
C:\blah>gitut
Unknown command: "


These are the available commands for gitut.


diff    Shows the difference between your code, and the example reference code
done    Checks out the code for the current step and tells you what to do for the next step.
help    Shows a list of commands or the help for a command.
hint    Shows the code you are supposed to have when you have completed the current step.
start   Start a new gitut from a github `username/project`.
todo    Find out what you have to do next to complete this step.

Type `gitut [command]` (`command` without the brackets) to run a commmand.
For example, type `gitut help start` for more info about `start`.

C:\blah>gitut help start
Help for: start

Start a new gitut from a github `username/project`.

# Example

This will create a new tutor in the `testfixture-repo` folder.
It clones the repository from `https://github.com/ToJans/testfixture-repo`.

     gitut start ToJans/testfixture-repo


C:\blah>gitut start ToJans/testfixture-repo
Het systeem kan het opgegeven pad niet vinden.
Your project has been started in the folder testfixture-repo. Enjoy!
C:\blah>cd testfixture-repo

C:\blah\testfixture-repo>gitut todo
This is your next todo:


Update the README with the correct reference to the gitut project

And this is an ever longer description, that describes in great
detail all the steps you need to perform to accomplish this task.
C:\blah\testfixture-repo>gitut diff
This is the difference between your code and the example code on github:

diff --git a/README.md b/README.md
index a8d97ee..d020c38 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,4 @@
 testfixture-repo
 ================

-This repository is used as a test-fixture for the [gitut](http://github.com/ToJans/gitut) project.
+This repository is used as a test-fixture for the gitut project

C:\blah\testfixture-repo>gitut hint
C:\blah\testfixture-repo>echo this opened up a browser with the github commit
this opened up a browser with the github commit

C:\blah\testfixture-repo>gitut done
Getting the code for this step from github.

This is your next todo:


Do some more fine-tuning to the readme

It does not mather what exactly in this case
C:\blah\testfixture-repo>gitut diff
This is the difference between your code and the example code on github:

diff --git a/README.md b/README.md
index 21619d7..a8d97ee 100644
--- a/README.md
+++ b/README.md
@@ -2,5 +2,3 @@ testfixture-repo
 ================

 This repository is used as a test-fixture for the [gitut](http://github.com/ToJans/gitut) project.
-
-Add some blah here... (to test skipped commits)....

C:\blah\testfixture-repo>
```
