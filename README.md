# MiniPlayer

[![CI Status](https://img.shields.io/travis/3422983@gmail.com/MiniPlayer.svg?style=flat)](https://travis-ci.org/3422983@gmail.com/MiniPlayer)
[![Version](https://img.shields.io/cocoapods/v/MiniPlayer.svg?style=flat)](https://cocoapods.org/pods/MiniPlayer)
[![License](https://img.shields.io/cocoapods/l/MiniPlayer.svg?style=flat)](https://cocoapods.org/pods/MiniPlayer)
[![Platform](https://img.shields.io/cocoapods/p/MiniPlayer.svg?style=flat)](https://cocoapods.org/pods/MiniPlayer)

## How to use:

Just put UIView in your xib or storyboard and change class name on "MiniPlayer" 

### Set soundTrack property for using 

### Use @IBInspectable properties to customise (see example directory)

### For rule programmatically use :

    <p>func play()<p/>
    <p>func pause()<p/>
    <p>func stop()<p/>

### Follow MiniPlayerDelegate:

<p>func didPlay(player: MiniPlayer)<p/>
<p>func didStop(player: MiniPlayer)<p/>
<p>func didPause(player: MiniPlayer)<p/>

#### To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

### Swift 5.0;  >=iOS10.3 

## Installation

MiniPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MiniPlayer'
```

## Author

Vitaly Seroshatnov, v.s.seroshtanov@gmail.com

## License

MiniPlayer is available under the MIT license. See the LICENSE file for more info.


