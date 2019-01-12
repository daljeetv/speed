# [Speed](https://speed.io) 💨 Add incentives to your Github Issues.

Speed helps you incentivize your GitHub Issues so you can get your issues fixed ASAP.

- **Make Money** - Find issues to fix by highest bounty value.

- **Filter all the things** - Filter issues  by type, monetary incentive, expiration date, state and reason.

- **Search with prefix filters** - No more Jedi mind tricks. Combine a wide range of powerful search filters help you get straight to the notification you're looking for and focus on just what you need.

- **Open for everyone** - Speed developers use Speed to develop Speed. 100% developed and managed in the open on GitHub under a FLOSS license.

![Screenshot of  Octobox](app/assets/images/screenshot_octobox.png)

[![Build Status](https://travis-ci.org/daljeetv/speed.svg?branch=master)](https://travis-ci.org/daljeetv/speed)

## Why is this a thing?

If you use open source software, you probably find [GitHub Issues](https://github.com/issues) pretty lacking.

You don't know when your issues will be complete and there is no way to add monetary incentives to the issues you file. 

Speed adds the ability to add monetary bounties to Github issues so you can incentivize open source contributors to fix your issues in a timely manner.

## Table of Contents

- [Getting Started](#getting-started)
	- [Speed.io](#speedio)
	- [Install](#install)
	- [Desktop usage](#desktop-usage)
	- [Web extension](#web-extension)
- [Requirements](#requirements)
- [Keyboard shortcuts](#keyboard-shortcuts)

## Getting Started

### Speed.io

You can use Speed right now at [speed.io](https://speed.io), a shared instance hosted by the Octobox team.

**Note:** speed.io has Personal Access Tokens ([#185](https://github.com/octobox/octobox/pull/185)) intentionally disabled.

### Install

You can also host Speed yourself! See [the installation guide](docs/INSTALLATION.md)
for installation instructions and details regarding deployment to Heroku, Docker, and more.

### Desktop usage

You can run Speed locally as a desktop app too if you'd like, using [Nativefier](https://www.npmjs.com/package/nativefier):

```bash
npm install -g nativefier
nativefier "https://speed.io" # Or your own self-hosted URL
```

This will build a local application (.exe, .app, etc) and put it in your current folder, ready to use.

## Requirements

[Web notifications](https://github.com/settings/notifications) must be enabled in your GitHub settings for Speed to work.

<img width="757" alt="Notifications settings screen" src="https://cloud.githubusercontent.com/assets/1060/21509954/3a01794c-cc86-11e6-9bbc-9b33b55f85d1.png">

## Keyboard shortcuts

You can use keyboard shortcuts to navigate and perform certain actions:

 - `a` - Select/deselect all
 - `r` or `.` - Refresh list
 - `j` - Move down the list
 - `k` - Move up the list
 - `s` - Star current notification
 - `x` - Mark/unmark current notification
 - `y` or `e` - Archive current/marked notification(s)
 - `m` - Mute current/marked notification(s)
 - `d` - Mark current/marked notification(s) as read here and on GitHub
 - `o` or `Enter` - Open current notification in a new window

Press `?` for the help menu.

