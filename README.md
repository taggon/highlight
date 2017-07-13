<p align="center">
	<img src="https://user-images.githubusercontent.com/212034/28132290-577374c6-6777-11e7-9dd2-802606985c2b.png" width="256" height="256">
</p>

# Highlight

Highlight is a rich-featured syntax highlighter for Keynote slides that allows you to get syntax-highlighted code in RTF with one click.
Its main feature is based on [highlight.js](https://highlightjs.org/), which means 176 langauges and 79 styles are available.
Check out the [demo](https://highlightjs.org/static/demo/) to see what you get with the application.

## Features

From highlight.js:

* 176 languages and 79 styles
* Automatic language detection
* Multi-language code highlighting

Original featuers:

* Line numbers
* Custom font
* Global hotkey - you don't even need to click.
* Automatic updates
* Supports English and Korean - any constributions are appreciated. :)

## Installation

* Download the latest version [here](https://github.com/taggon/highlight/releases).
* Unarchive and run it.
* You may be asked to move it into Applications folder. I strongly recommend accepting it.

## Usage

* When you execute the application, you will see a highlighter icon on the menu bar as shown in the screenshot.
* Copy any code you want to colorize.
  ![](https://cloud.githubusercontent.com/assets/212034/24546063/a94b57c0-1644-11e7-9eb7-47e5d1c6526c.png)
* Click on the icon to open the popup menu. Select Highlight Code and then pick your programming language
or just choose the auto-detect one. Now the code is syntax-highligted.   
  ![](https://cloud.githubusercontent.com/assets/212034/24546095/c523e278-1644-11e7-80ab-3637c369ae4a.png)
* Paste the code wherever you want (e.g. Keynote).
  ![](https://cloud.githubusercontent.com/assets/212034/24546179/03231210-1645-11e7-8ec8-6ab11600dfd6.png)

Want to customize results? Open Preferences dialog.

## Contribution

Highlight supports multi-language UI, currently only for English and Korean.
If you're interested in translating the application, start by copying
[the Korean translation folder](https://github.com/taggon/highlight/tree/master/Highlight/ko.lproj) into your respective language folder
(e.g. pr.lproj for Portuguese, ru.lproj for Russian, etc).

You need to translate all files in the folder except [MoveApplication.strings](https://github.com/taggon/highlight/blob/master/Highlight/ko.lproj/MoveApplication.strings)
that comes from [LetsMove](https://github.com/potionfactory/LetsMove) project.
I will copy the file for your language from the project as soon as your translation is merged into the master branch.

