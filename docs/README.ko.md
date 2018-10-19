<p align="center">
	<img src="https://user-images.githubusercontent.com/212034/28132290-577374c6-6777-11e7-9dd2-802606985c2b.png" width="256" height="256">
</p>

[[English](https://github.com/taggon/highlight/blob/master/README.md)]
[[한국어](https://github.com/taggon/highlight/blob/master/docs/README.ko.md)]

# Highlight

Highlight는 클릭 한 번으로 키노트 슬라이드에 문법이 강조되어 색상이 입혀진 RTF 형식의 코드를 붙여넣을 수 있으며, 다양한 기능을 갖춘 문법 강조 프로그램입니다.
주요 기능은 [highlight.js](https://highlightjs.org/)를 기반으로 하고 있으므로, 마찬가지로 176개의 언어와 79개의 스타일을 지원합니다.
이 애플리케이션을 사용했을 때 코드가 어떻게 표현되는지 궁금한 분은 [데모](https://highlightjs.org/static/demo/)를 확인해보시기 바랍니다.

## 기능

highlight.js의 기능:

* 176개 언어와 79개 스타일
* 언어 자동 감지
* 다중 언어 코드 문법 강조

고유 기능:

* 줄 번호
* 커스텀 폰트
* 전역 단축키 - 클릭조차 필요없습니다.
* 자동 업데이트
* 다국어 UI 지원
  * 영어
  * 한국어
  * 터키어 - [@tosbaha](https://github.com/tosbaha)님
  * 중국어(간체) - [@xnth97](https://github.com/xnth97)님

다른 언어 번역도 환영합니다. :)

## 설치

* [여기](https://github.com/taggon/highlight/releases)에서 최신 버전을 다운로드 받습니다.
* 압축을 해제하고 애플리케이션을 실행합니다.
* 응용프로그램 폴더로 프로그램을 이동하라는 요청이 있을 수 있습니다. 원활한 이용을 위해 가능하면 허용할 것을 권장합니다.

## 사용법

![](https://user-images.githubusercontent.com/212034/28166880-98238d06-6814-11e7-9418-83a286a8a67d.gif)

* 애플리케이션을 실행하면 아래 스크린샷처럼 형광펜 아이콘이 나타납니다.  
![](https://user-images.githubusercontent.com/212034/28166990-f05c99fe-6814-11e7-9ec8-c7569a20763d.png)
* 구문 강조 색상을 입힐 코드를 복사합니다.
* 메뉴바에서 아이콘을 클릭해 팝업 메뉴를 엽니다. 구문 강조 후 복사 메뉴에서 프로그래밍 언어를 고르거나 구문강조 후 복사(언어 자동 감지)를 클릭합니다. 이제 코드에 구문강조 색상이 입혀졌을 것입니다.
* 원하는 곳(예. 키노트)에 코드를 붙여넣습니다.

더 자세하게 결과물을 조절하고 싶다면? 환경설정 대화상자를 살펴보시기 바랍니다.

## 빌드하는 법

[CocoaPods](https://cocoapods.org/)를 설치한 후 다음 명령어를 프로젝트 루트 폴더에서 실행합니다.
[NodeJS](https://nodejs.org)도 필요하므로 미리 설치해두세요.

```
$ pods update && pods install
$ npm i
```

프로젝트의 워크스페이스 파일(`Highlight.xcworkspace`)를 열어서 빌드를 실행합니다.

## 기여 방법

Highlight는 다국어 UI를 지원하는데 현재는 영어와 한국어를 지원합니다.
이 애플리케이션을 번역하고 싶다면 먼저
[한국어 번역 폴더](https://github.com/taggon/highlight/tree/master/Highlight/ko.lproj)를 원하는 언어
(예. 포르투갈어라면 pr.lproj, 러시아어라면 ru.lproj 등)에 해당하는 폴더로 복사하세요.

폴더 안에 있는 파일은 모두 번역해주셔야 합니다. 단, MoveApplication.strings 파일은 [LetsMove](https://github.com/potionfactory/LetsMove) 프로젝트에서 가져 온 것이므로 해당 프로젝트에 번역 파일이 존재한다면 그대로 복사해서 사용해도 괜찮습니다.
