# README

*noexcuses* - runs important cronjobs until they succeed

# Description

Sometimes cronjobs fail to run successfully because a required server (like
a database or FTP server) is temporarily unavailable due to power failures,
hardware failures, software failures, network outages, choice of operating
system, pilot error, and the like.

Typically, this results in someone being forced to examine crontabs and
error reports, determine which cronjobs really need to be run, and then run
them manually. This happened to me twice in one week. I don't want it to
happen again. Cronjobs are meant to be automated and I want them to stay
that way.

This is the rationale for *noexcuses*. It keeps track of cronjobs that have
failed and keeps running them until they succeed. All you have to do is look
at your crontabs, identify the cronjobs-that-must-succeed-no-matter-what and
insert `noexcuses` before the command.

Then, when *cron* runs *noexcuses*, *noexcuses* will run the given cronjob.
If the cronjob fails, *noexcuses* becomes a daemon that will retry the
cronjob regularly until it succeeds. Even if the cron host is rebooted
before the cronjob succeeds, *noexcuses* lets you restart all of the
outstanding cronjobs. Even if the cron host is down for a while, *noexcuses*
can tell you which cronjobs missed out on running while it was down and run
them. The initscript `noexcuses.init` can make this happen automatically at
boot time.

In other words, *noexcuses* is a free, lightweight, fine-grained,
unobtrusive, high-availability tool for cronjobs. Or rather, it's a
high-recoverability tool for cronjobs which can either be incorporated into
a highly available system or used in the absence of one.

*noexcuses* is freely available under the terms of the [GNU General Public
License](https://www.gnu.org/licenses/), either version 2 of the License, or
(at your option) any later version.

# Features

  * Retry failed cronjobs until they succeed
  * List outstanding jobs
  * Retry outstanding jobs now
  * Cancel outstanding jobs
  * Recover cronjobs missing due to downtime
  * Adopt another cron host's outstanding jobs
  * Forget jobs adopted by another host

# Requirements

*noexcuses* is written in Perl, and uses *pod2man* and *pod2html* which come
with Perl. It does not require any non-standard Perl modules. It does
require a POSIX system and *cron*.

# Documentation

There is a manual entry:

  - [noexcuses(1)](http://raf.org/noexcuses/manpages/noexcuses.1.html) - the *noexcuses(1)* manpage

--------------------------------------------------------------------------------

    URL: http://raf.org/noexcuses
    GIT: https://github.com/raforg/noexcuses
    Date: 20200625
    Author: raf <raf@raf.org>

