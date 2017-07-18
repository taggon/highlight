<p align="center">
	<img src="https://user-images.githubusercontent.com/212034/28132290-577374c6-6777-11e7-9dd2-802606985c2b.png" width="256" height="256">
</p>

[[English](https://github.com/taggon/highlight/blob/master/README.md)]
[[한국어](https://github.com/taggon/highlight/blob/master/docs/README.ko.md)]

# Highlight

Highlight is a rich-featured syntax highlighter for Keynote slides that allows you to get syntax-highlighted code in RTF with one click.
Its main feature is based on [highlight.js](https://highlightjs.org/), which means 176 langauges and 79 styles are available.
Check out the [demo](https://highlightjs.org/static/demo/) to see what you get with the application.

## Features

From highlight.js:

* 176 languages and 79 styles
* Automatic language detection
* Multi-language code highlighting

Original features:

* Line numbers
* Custom font
* Global hotkey - you don't even need to click.
* Automatic updates
* Supports English and Korean - any constributions are appreciated. :)

## Installation

* Download the latest version [here](https://github.com/taggon/highlight/releases).
* Unarchive it and then run the application.
* You may be asked to move it into Applications folder. I strongly recommend accepting it.

## Usage

![](https://user-images.githubusercontent.com/212034/28166880-98238d06-6814-11e7-9418-83a286a8a67d.gif)

* When you execute the application, you will see a highlighter icon on the menubar as shown in the screenshot.  
![](https://user-images.githubusercontent.com/212034/28166990-f05c99fe-6814-11e7-9ec8-c7569a20763d.png)
* Copy any code you want to colorize.
* Click on the icon to open the popup menu. Select Highlight Code and then pick your programming language
or just choose the auto-detect one. Now the code is syntax-highligted.
* Paste the code wherever you want (e.g. Keynote).

Want to customize results? Open the Preferences dialog.

## Contribution

Highlight supports multi-language UI, currently only for English and Korean.
If you're interested in translating the application, start by copying
[the Korean translation folder](https://github.com/taggon/highlight/tree/master/Highlight/ko.lproj) into your respective language folder
(e.g. pr.lproj for Portuguese, ru.lproj for Russian, etc).

You need to translate all files in the folder except [MoveApplication.strings](https://github.com/taggon/highlight/blob/master/Highlight/ko.lproj/MoveApplication.strings)
that comes from [LetsMove](https://github.com/potionfactory/LetsMove) project.
I will copy the file for your language from the project as soon as your translation is merged into the master branch.
