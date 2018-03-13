# Contributing to the telegraf Community Cookbook

We're glad you want to contribute to telegraf cookbook! The first step is the desire to improve the project.

## Submitting Issues

Not every contribution comes in the form of code. Submitting, confirming, and triaging issues is an important task for any project.

We ask you not to submit security concerns via GitHub.

## Contribution Process

We have a 3 step process for contributions:

1. Commit changes to a git branch.
2. Create a GitHub Pull Request for your change.
3. Perform a [Code Review](#code-review-process) with the cookbook maintainers on the pull request.

### Pull Request Requirements

Chef cookbooks are built to last. We strive to ensure high quality throughout the experience. In order to ensure this, all pull requests must meet these specifications:

* **Tests:** To ensure high quality code and protect against future regressions, we require all cookbook code to be tested in some way. This can be either unit testing with ChefSpec or integration testing with Test Kitchen / InSpec. See the TESTING.md file for additional information on testing in Chef cookbooks and feel free to ask if you need help with the testing process.

### Code Review Process

Code review takes place in GitHub pull requests. See [this article](https://help.github.com/articles/about-pull-requests/) if you're not familiar with GitHub Pull Requests.

Once you open a pull request, cookbook maintainers will review your code using the built-in code review process in Github PRs. The process at this point is as follows:

1. A cookbook maintainer will review your code and merge it if no changes are necessary. Your change will be merged into the cookbooks's `master` branch and will be noted in the cookbook's `CHANGELOG.md` at the time of release.
2. If a maintainer has feedback or questions on your changes they they will set `request changes` in the review and provide an explanation.

## Cookbook Contribution Do's and Don't's

Please do include tests for your contribution. If you need help, ask
on the
[chef-dev mailing list](http://lists.opscode.com/sympa/info/chef-dev)
or the
[#chef-hacking IRC channel](http://community.opscode.com/chat/chef-hacking).
Not all platforms that a cookbook supports may be supported by Test
Kitchen. Please provide evidence of testing your contribution if it
isn't trivial so we don't have to duplicate effort in testing. Chef
10.14+ "doc" formatted output is sufficient.

Please do indicate new platform (families) or platform versions in the
commit message, and update the relevant ticket.  If a contribution adds 
new platforms or platform versions, indicate such in the body of the commit message(s).

Please do use [cookstyle](http://www.foodcritic.io/) and [foodcritic](http://www.foodcritic.io/) to
lint-check the cookbook.

Please do ensure that your changes do not break or modify behavior for
other platforms supported by the cookbook. For example if your changes
are for Debian, make sure that they do not break on CentOS.

Please do not modify the version number in the metadata.rb, the maintainer
will select the appropriate version based on the release cycle
information above.

Please do not update the CHANGELOG.md for a new version. Not all
changes to a cookbook may be merged and released in the same versions.
We will update the CHANGELOG.md when releasing a new version of
the cookbook.
