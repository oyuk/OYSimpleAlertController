# OYSimpleAlertController

OYSimpleAlertController is very simple Alert written in Swift.


![alt tag](https://github.com/oyuk/OYSimpleAlertController/blob/master/Assets/OYSimpleAlertController.gif)

## Usage
```Swift
let alert = OYSimpleAlertController(title: "Title", message: "message")
let defaultAction = OYAlertAction(title: "OK", actionStyle: .Default, actionHandler: {
print("OK")
})

alert.addAction(defaultAction)

presentViewController(alert, animated: true, completion: nil)
```
## Design

###Title
```Swift
alert.alertTitleColor = UIColor.whiteColor()
alert.alertTitleFont = UIFont.boldSystemFontOfSize(23)
alert.alertTitleBackgroundColor  = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)  
``` 
###Message   
```Swift
alert.messageColor = UIColor.blackColor()
alert.messageFont = UIFont.systemFontOfSize(18)
```
###Button
```Swift
alert.buttonFont = UIFont.boldSystemFontOfSize(23)
alert.buttonTextColor = UIColor.whiteColor()
alert.buttonBackgroundColors[.Default] = UIColor(red: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1.0)
```

## Installation

OYSimpleAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OYSimpleAlertController"
```

## Author

oyuk, okysoft68@gmail.com

## License

OYSimpleAlertController is available under the MIT license. See the LICENSE file for more info.

