THSegmentedControl
========
![demo](Example/SegmentedControl.gif)

THSegmentedControl is a direct subclass of UIResponder and mimics the current functionality of UISegmentedControl with the added benefit of being able to perform multiple selection.

##Usage
###Alloc/Init it just like you would a normal UISegmentedControl:
``` objc
NSArray *segments = @[@"White", @"Black", @"Gold"];
THSegmentedControl *thControl = [[THSegmentedControl alloc] initWithSegments:segments];

// OR

NSArray *segments = @[@"White", @"Black", @"Gold"];
THSegmentedControl *thControl = [[THSegmentedControl alloc] init];

for (int i = 0; i < segments.count; i++) {
  [thControl insertSegmentWithTitle:segments[i] atIndex:i];
}
```

###Sign up for some target action:
``` objc
[thControl addTarget:self action:@selector(thControlChangedSegment:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchUpInside];
```

###Profit:
``` objc
- (void)thControlChangedSegment:(THSegmentedControl *)thSegmentedControl
{
    NSOrderedSet *orderedIndexes = thSegmentedControl.selectedIndexes;
    for (NSInteger selection in orderedIndexes) {
      NSLog("I'm a selected segment %@", [thSegmentedControl titleForSegmentAtIndex:index]);
    }
}
```

##To-Do  
* Accept images for segments
* Add tests
* Anything else you would like to see, send through a PR

License
-------
Released under the [MIT License](LICENSE).
