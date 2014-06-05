#Contributing

Here we will elaborate on some guidelines on how one can contribute to this project. Please feel free to ask more questions. Again, the following is a guidline and there is plenty of grey area.

#Git Flow

##Branching

Our Git flow is a simplifed [Git-Flow](http://nvie.com/posts/a-successful-git-branching-model/). Much like Git-Flow, we take advantage of a master branch, a development branch, and feature branches.

###The master branch
This branch remains readily deployable at all times. It has no end to it's lifespan and only heavily tested code (or no code at all) is allowed in this exclusive branch.

###The Development Branch
This branch is where all ongoing work is done. It runs parallel to master, and incorporates all bugfixes and features. When the head of the development branch is tested and meets our coding requirements (to be discussed later), it graduates and gets merged to master via pull request.

###Feature Branches
Feature branches branch off of development and must be merged back into development. When working on a feature branch, it is important to only make changes that are relevant to the feature you are currently working on. Thus the lifespan of the feature branch is limited to the development of that feature.

For simplicity, we shall eschew hotfix and release branches.

##Committing

Commit often! Your commits tell the story of your project. Each commit should reflect what changes you made to the code base, and should be coherent, cohesive, concise, and isolated. This way it becomes easy to track what change affects the product as a whole.

We expect to have well written commit messages. Your commits should reflect what changes you made to the code base, and should be coherent, cohesive, concise, and isolated. That being said, the message itself should be written in the imperative. The end result will have your Git Commit history looking like a recipe for success!

For example, when I finish this document and submit it, my git commit will probably be:

```
Add CONTRIBUTING.md

Add documentation for expectations on contributing.
```


##Pull Requests

When you're confident in your code you're going to want to send in a pull request. You're commit history will be able to tell the code maintainer what you've changed and how it will affect the codebase. It may be a good idea to summarize what you have done in the pull request message, and how it will affect the codebase. To be more certain in your own code, you may want to ask for a code review.

###Code Review

After sending your pull request, your code will get reviewed to make sure merging it wont break the branch it's merging into. This is a good time to ask any questions or concerns you have. Code reviews also help get fresh set of eyes to look at your code, and if those eyes are alsow working on the project, it lets them get familiar with the new code base.


#Continuous Integration

Testing over and over again is a pain, make someone else do it. Continuous Integration is a bliss because someone else is doign the testing. Continuous Integration is constantly hammering our code with quality control metrics in hopes that we churn out better code. The core of this is our tests, but code coverage and quality are all part of Continous Integration.

We use two methods of testing in our Continuous Integration suite. The open, public one is [Travis](https://travis-ci.org/NYULibraries/ichabod), which builds our project and runs our tests. The closed, private one is Jenkins, which builds our projects, runs our tests, and deploys for us if everything passes. Everytime you make a Git commit, Jenkins will run it and see if it passes, emailing you if it failed. Likewise, Travis will do the same. The difference is Jenkins will also deploy, allowing you to see the changes you made.

For code quality, we use Code Climate, and for coverage we use Coveralls!

#Testing

We expect our code to pass through a comprehensive testing suite that includes RSpec and Cucumber.

This may seem daunting, but thats only because the tests haven't been written. Writing tests is scary, the code you worked hard on fails, and then you have to go back and change it without any other tests failing. It's like playing Operation without the zany buzzer. Maybe that's what surgery feels like, I wouldn't know I haven't done surgery. Fortunately nobody's life is on the line for this particular project.

Now imagine Cavity Sam was told he probably shouldn't put strange things in his body, he would never make it to the Operation table! That is what Test Driven Design is about. You make the tests first so you don't have to use evasive surgical maneuvers on your code.

###RSpec
Don't worry about your code, worry about the tests. Use RSpec to specify exactly what your code is supposed to do. Then watch it fail. It is important you let it fail, and that you let it fail in every imaginable way. After it has failed make more tests and let it fail again. Let the fail flow trough you.

Check out the spec for the [Figsfile](https://github.com/NYULibraries/figs/blob/master/spec/figs/figfile_spec.rb) in [Figs](https://github.com/NYULibraries/figs). It has 83 lines, describing four methods across a couple of contexts. The spec was written before any code. All that needed to be done was to make these tests pass. Which was done, with only [14 lines of code](https://github.com/NYULibraries/figs/blob/master/lib/figs/figsfile.rb).

You'll find that you will write less code, which means less complexity, that is well tested. Your margin of error is greatly reduced by this.


###Cucumber
Now writing RSpec is your main objective. Translating english to code is not always easy, and you may end up testing individual pieces of code that pass, but catastrophically fail when running together. Cucumber makes it easy to take our Test Driven Design and make it into Behavior Driven Design.

With Cucumber, you may describe a feature in plain english, then define the steps in Ruby (with RSpec), and finally let it fail. This will have the added benefit of documenting what your code is doing and what you are testing for. The resulting code you write to make it pass is merely the side effects of using BDD.

#Code Quality

Overall code quality is important. Code quality is more than code that looks good, its about reducing [code smells](http://martinfowler.com/bliki/CodeSmell.html). We want to stay away from smelly code, but sometimes we don't smell our own code, and unless someone tells us, we'll never know our code has smells.

##Smells
Code smells aren't hard to look out for, especially when we're using [Code Climate](https://codeclimate.com/github/NYULibraries/ichabod/). Code Climate points out what kind of smells are present in your code. In total, Code Climate detects four main smells.

* __Duplication__ - Syntax structures that seem to come up more often than they should.
* __Complex method__ — Too much branching, too many loops, too many method calls all account for complexity.
* __Complex class/module definition__ — Much like a long and complex method, this smell means a class is long and complex. This happens when there are is too much code in the class definition that isn't part of any method.
* __High total complexity of a class/module__ — If a class gets too large, and has too many methods, this signifies that maybe the class has too much responsibility.

With this rubric you can carry one simplifying your code and aim for a very high GPA (what Code Climate uses to grade code quality).

##Coverage
[Coveralls](https://coveralls.io/r/NYULibraries/ichabod?branch=development) is a pretty important player as well. Coveralls shows us what percentage of code was tested. It's tightly integrated with Travis, so when Travis runs the tests, it also runs the coveralls gem, which takes metrics. Then, Travis sends those metrics to Coveralls, allowing us to see what lines of code were run during the tests, and how many times they were run. You are tasked to get as close to 100% code coverage as computerly possible.


#Issue Tracking

If you find any issues in the code base, feel free to open up an issue using GitHub's awesome [issues](https://github.com/NYULibraries/ichabod/issues) feature. You can assign issues to users, label them, and set them to milestones!

Best part is, you can then close the issues via [git commit](https://help.github.com/articles/closing-issues-via-commit-messages). 



#Documentation

We hope that with the use of RSpec and Cucumber, along with good coding practice that emphasises cleaner and simpler code, the code will become self documenting. What that means is that we expect variable, class, and method names to be descriptive enough that the person viewing the code understands what it's purpose is.

Self documenting code does not mean your code will be void of any sort of documentation, far from it. Self documentation means it won't rely on heavy documentation for a peer to figure out what is going on.

A good rule of thumb is that if your code requires documentation to explain exactly what is going on, it's probably a code smell. Sometimes the best way to do something is highly abstract, so it's a good idea to drop a comment explaining whats going on.

For best practices, give every class, method, and variable a clear, semantic name, along with comments explaining the codes purpose. Try to avoid cluttered comments and large methods. The human eye is attracted to empty space, so breaking up large blocks of code to succinct blocks with small comments is highly visible and easier to follow.

#More Resources

* [Blog post on our workflows](https://web1.library.nyu.edu/libtechnyu/blog/2013/05/21/development-workflows/)
* [Some more info on pull requests, and why code reviews are important](https://www.igvita.com/2011/12/19/dont-push-your-pull-requests/).
* [5 useful tips on how to write a better git commit message](http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message)
* [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html). 



