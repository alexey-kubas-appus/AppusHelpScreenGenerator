HelpScreenGenerator
=====================

Made by [![Appus Studio](https://github.com/appus-studio/Appus-Splash/blob/master/image/logo.png)](http://appus.pro)

'HelpScreenGenerator' is a component, which gives you an opportunity to easily make a help screens for Your app

* [Configuration](#configuration)
* [Usage](#usage)
* [Setup](#setup)
* [Info](#info)

#Configuration:

## Objective-C

* Import auto generated “ProjectName-Swift.h” file and inherit Delegate and DataSource

* Create properties and configure them
```
HelpScreenView *helpScreenView;
NSMutableArray *hintsDataSource;
UIWindow *window = [appDelegate window];
self.helpScreenView = [[HelpScreenView alloc] initWithFrame:window.bounds];
self.helpScreenView.delegate = self;
self.helpScreenView.dataSource = self;
[window addSubview:self.helpScreenView];
``` 
* Implement Delegate and DataSource
	
```
Required for hint with .Custom hint position, must provide rect in bounds of HelpScreenView
- (CGRect)rectForHint:(HelpScreenView * __nonnull)helpScreenView hint:(Hint * __nonnull)hint atIndex:(NSInteger)atIndex;

Returns  number of hints in data source
- (NSInteger)numberOfHints:(HelpScreenView * __nonnull)helpScreenView;

Returns  child Hint class instanse
- (Hint * __nonnull)hintForIndex:(HelpScreenView * __nonnull)helpScreenView index:(NSInteger)index;

Returns view which should be blurred or nil
- (UIView * __nonnull)viewForBlurring;
```

* Fill hintsDataSource and reload HelpScreenView:
```
[[TextHint alloc] initWithTarget:UIView
                            text:NSString];
	                            
[[TextHint alloc] initWithTarget:UIView
                            text:NSString
                      bubbleType:BubbleType
                           sizes:NSArray<NSValue*>]; //[NSValue valueWithCGRect:CGRect]
	                           
[[TextHint alloc] initWithTargetRect:CGRect
                                text:NSString
                          bubbleType:BubbleType];
                          
[[ImageHint alloc] initWithTargetRect:CGRect
                                image:UIImage
             imageContentMode:UIViewContentMode
                   bubbleType:BubbleType
                        sizes:NSArray<NSValue*>]; //[NSValue valueWithCGRect:CGRect]
	                                
[[ViewHint alloc] initWithTarget:UIView view:UIView];

[self.helpScreenView reloadData]; //Call when UI already configured viewDidAppear etc.
```
# Swift

* Inherit Delegate and DataSource
```
class SomeClass: UIViewController, HelpScreenViewDelegate, HelpScreenViewDataSource
```
* Create properties and configure them
```
var helpView: HelpScreenView!
    
var hintsDataSource = [Hint]()

self.helpView = HelpScreenView()

self.helpView.delegate = self

self.helpView.dataSource = self

if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
    self.helpView.addToView(window)
}  
```
* Implement Delegate and DataSource

* Fill hintsDataSource and reload HelpScreenView
```
TextHint(target:UIView! ,text:String ,bubbleType:BubbleType ,sizes:[NSValue]) //[NSValue valueWithCGRect:CGRect]
	
ImageHint(targetRect:CGRect ,image: UIImage)
	
ViewHint(target:UIView! ,view: UIView)

helpView.reloadData() //Call when UI already configured viewDidAppear etc. 
```
#Usage:

![](https://github.com/alexey-kubas-appus/HelpScreenGenerator/blob/master/Resouces/usage.gif)

#Setup:
```Ruby
pod 'HelpScreenGenerator'
```

Developed By
------------

* Alexey Kubas, Sergey Sokoltsov, Andrey Pervushin, Appus Studio

License
--------

    Copyright 2015 Appus Studio.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
