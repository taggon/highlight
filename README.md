<p align="center">
	<img src="https://user-images.githubusercontent.com/212034/28132290-577374c6-6777-11e7-9dd2-802606985c2b.png" width="256" height="256">
</p>

[[English](https://github.com/taggon/highlight/blob/master/README.md)]
[[한국어](https://github.com/taggon/highlight/blob/master/docs/README.ko.md)]

# Highlight

Highlight is a rich-featured syntax highlighter for Keynote slides that allows you to get syntax-highlighted code in RTF with one click.
Its main feature is based on [highlight.js](https://highlightjs.org/), which means 185 langauges and 89 styles are available.
Check out the [demo](https://highlightjs.org/static/demo/) to see what you get with the application.

## Features

From highlight.js:

* 191 languages and 238 styles
* Automatic language detection
* Multi-language code highlighting

Original features:

* Line numbers
* Custom font
* Global hotkey - you don't even need to click.
* Automatic updates
* Supports multi-language UI
  * English
  * Korean
  * Turkish - Thanks to [@tosbaha](https://github.com/tosbaha)
  * Chinese Simplified - Thanks to [@xnth97](https://github.com/xnth97)

Want to add support for your language? Send me translations! :)

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

Do you like to customize the results? Just open the Preferences dialog. You will see how.

## How to build

Once you install [CocoaPods](https://cocoapods.org/) on your system, run the following command in the project root directory.
You may need to setup [NodeJS](https://nodejs.org).

```
$ pod install
$ npm install
```

Open the workspace by double-clicking `Highlight.xcworkspace` then build it. It should just work.

## Contribution

Highlight supports multi-language UI, currently only for few languages including English and Korean.
If you're interested in translating the application, start by copying
[the Korean translation folder](https://github.com/taggon/highlight/tree/master/Highlight/ko.lproj) into your respective language folder
(e.g. pr.lproj for Portuguese, ru.lproj for Russian, etc).

You need to translate all files in the folder. Because the MoveApplication.strings comes from [LetsMove](https://github.com/potionfactory/LetsMove) project, you can copy the same file from the project if exists.
