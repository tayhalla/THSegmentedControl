//
//  THMultipleSelectionSegmentedControl.m
//
//  Created by Taylor Halliday on 11/20/13.
//  Copyright (c) 2013 5Celsius. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import "THSegmentedControl.h"

// Forward declaration for delegate protocol
@class THSegmentedControlSegment;

/**
 `THSegmentedControlSegmentDelegate` is designed to let the owner of this control decide whether or not to allow a specific content selection.
 If not implemented, the control will default to allowing all segments to be selected.
 */

@protocol THSegmentedControlSegmentDelegate <NSObject>

- (BOOL)allowSegment:(THSegmentedControlSegment *)segment toHighlight:(BOOL)highlighted withIndex:(NSInteger)index;

@end

// Default point gap for seperators
NSInteger const THSegmentedControlSeperatorWidth = 1;

// Default animation constant for color switch duration
float const THSegmentedControlAnimationDuration = 0.1f;

@interface THSegmentedControl () <THSegmentedControlSegmentDelegate>

@property (nonatomic, strong) NSMutableArray      *segments;
@property (nonatomic, strong) NSMutableArray      *segmentLabels;
@property (nonatomic, strong) NSMutableArray      *segmentSeperators;
@property (nonatomic, strong) NSMutableOrderedSet *selectedIndexSet;

@end

@interface THSegmentedControlSegment : UIView

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index;

@property (readwrite, nonatomic, strong) NSString   *title;
@property (readwrite, nonatomic, strong) UIFont     *font;
@property (readwrite, nonatomic, strong) UIColor    *segmentBackgroundColor;
@property (readwrite, nonatomic, strong) UIColor    *segmentHighlightedBackgroundColor;
@property (readwrite, nonatomic) NSInteger index;
@property (nonatomic) BOOL selected;
@property (nonatomic) id <THSegmentedControlSegmentDelegate> delegate;

@end

@implementation THSegmentedControl

@synthesize tintColor = _tintColor;

#pragma mark - THSegmentControl Init Methods

- (instancetype)initWithSegments:(NSArray *)segments
{
    self = [super init];
    if (self) {
        [self commonInit];
        for (int i = 0; i < segments.count; i++) {
            [self insertSegmentWithTitle:segments[i] atIndex:i];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.segments = [[NSMutableArray alloc] initWithCapacity:10];
    self.selectedIndexes = [[NSMutableOrderedSet alloc] initWithCapacity:10];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 1.0f;
}

#pragma mark - Getter for selected indexes

- (NSOrderedSet *)selectedIndexes
{
    if (_selectedIndexSet) {
        return [_selectedIndexSet copy];
    }
    return [[NSOrderedSet alloc] init];
}

- (void)setSelectedIndexes:(NSOrderedSet *)selectedIndexes
{
    if (!selectedIndexes) {
        _selectedIndexSet = [[NSMutableOrderedSet alloc] init];
    } else if (_selectedIndexSet != selectedIndexes) {
        _selectedIndexSet = [selectedIndexes mutableCopy];
    }
}

#pragma mark - THSegmentedControl Public Instance Methods

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment
{
    while (segment > self.segments.count) {
        [self.segments insertObject:@"" atIndex:self.segments.count];
    }
    [self.segments insertObject:[title copy] atIndex:segment];
    [self setNeedsDisplay];
}

- (NSArray *)titlesForSegmentsAtIndexes:(NSOrderedSet *)indexes
{
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:indexes.count];
    for (NSNumber *index in indexes) {
        NSInteger ind = [index integerValue];
        NSString *title = [self titleForSegmentAtIndex:ind];
        if (title) [titles addObject:title];
    }
    return titles;
}

- (NSString *)titleForSegmentAtIndex:(NSInteger)index
{
    if (index < self.segments.count) {
        return [(NSString *)self.segments[index] copy];
    } else {
        return nil;
    }
}

- (void)removeSegmentsAtIndex:(NSInteger)index
{
    [self.segments removeObjectAtIndex:index];
    [self setNeedsDisplay];
}

- (NSInteger)numberOfSegments
{
    return self.segments.count;
}

- (void)removeAllSegments
{
    self.segments = [[NSMutableArray alloc] initWithCapacity:10];
    [self setNeedsDisplay];
}

#pragma mark - UIView drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.segments.count > 0) {
        CGRect modifiedRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - (self.segments.count - 1), rect.size.height);
        [self clearExistingSeperatorsAndLabels];
        // Due to pixels, I need to layout the seperators first. Segments and
        // frames can create fractional layouts with unintended whitespace. This way
        // I layout the seperators, then fill in the segments as needed.
        
        for (int i = 0; i < self.segments.count; i++) {
            [self layoutSeperatorsWithIndex:i rect:modifiedRect];
        }
        
        for (int i = 0; i < self.segments.count; i++) {
            [self layoutSectionWithIndex:i rect:modifiedRect selected:[self.selectedIndexes containsObject:[NSNumber numberWithInt:i]]];
        }
    }
    [self ensureProperSeperatorColor];
}

- (void)layoutSectionWithIndex:(NSInteger)index rect:(CGRect)rect selected:(BOOL)selected
{
    // Segment Layout
    CGFloat xOrigin;
    CGFloat width;
    
    if (self.segments.count == 0) {
        xOrigin = 0.0f;
        width = self.bounds.size.width;
    } else if ((self.segments.count - 1) == index) {
        xOrigin = (((UIView *)self.segmentSeperators[index - 1]).frame.origin.x + ((UIView *)self.segmentSeperators[index - 1]).frame.size.width);
        width = self.bounds.size.width - xOrigin;
    } else {
        if (index == 0) {
            xOrigin = 0.0f;
        } else {
            UIView *previousSeperator = self.segmentSeperators[index - 1];
            xOrigin = previousSeperator ? previousSeperator.frame.origin.x + previousSeperator.frame.size.width : 0.0f;
        }
        UIView *nextSeperator = self.segmentSeperators[index];
        width = nextSeperator.frame.origin.x - xOrigin;
    }
    
    CGRect segFrame = CGRectMake(xOrigin, rect.origin.y, width, rect.size.height);
    THSegmentedControlSegment *segLabel = [self segmentLabelWithFrame:segFrame text:self.segments[index]];
    segLabel.selected = selected;
    segLabel.index = index;
    [self addSubview:segLabel];
}

// Init for the segment
- (THSegmentedControlSegment *)segmentLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    THSegmentedControlSegment *segLabel = [[THSegmentedControlSegment alloc] initWithFrame:frame];
    segLabel.title = text;
    
    segLabel.segmentBackgroundColor = self.backgroundColor;
    segLabel.segmentHighlightedBackgroundColor = self.tintColor;
    segLabel.delegate = self;
    [segLabel setFont:self.font];
    return segLabel;
}

- (void)layoutSeperatorsWithIndex:(NSInteger)index rect:(CGRect)rect
{
    
    if ((index + 1) < self.segments.count) {
        int xOrigin = ((self.bounds.size.width / self.segments.count) * (index + 1)) - (0.5 * (float)THSegmentedControlSeperatorWidth);
        CGRect seperatorFrame = CGRectMake(xOrigin,
                                           rect.origin.y,
                                           THSegmentedControlSeperatorWidth,
                                           rect.size.height);
        UIView *seperator = [self segmentSeperatorWithFrame:seperatorFrame];
        [self.segmentSeperators addObject:seperator];
        [self addSubview:seperator];
    }
}

- (UIView *)segmentSeperatorWithFrame:(CGRect)seperatorFrame
{
    UIView *segSeperator = [[UIView alloc] initWithFrame:seperatorFrame];
    segSeperator.backgroundColor = self.tintColor;
    return segSeperator;
}

- (CGFloat)segmentWidthWithRect:(CGRect)rect
{
    CGFloat totalSegmentWidth = ((self.segments.count -1) * THSegmentedControlSeperatorWidth);
    CGFloat segmentWidth = (rect.size.width  - totalSegmentWidth)/ self.segments.count;
    return segmentWidth;
}

- (void)clearExistingSeperatorsAndLabels
{
    for (UILabel *label in self.segmentLabels) {
        [label removeFromSuperview];
    }
    
    for (UIView *seperator in self.segmentSeperators) {
        [seperator removeFromSuperview];
    }
    
    self.segmentLabels = [[NSMutableArray alloc] initWithCapacity:10];
    self.segmentSeperators = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)ensureProperSeperatorColor
{
    NSUInteger sentinelCount = [[self.selectedIndexes array] count]  - 1;
    NSMutableSet *segmentSet = [[NSMutableSet alloc] initWithCapacity:self.selectedIndexes.count];
    
    [self.selectedIndexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger selectedIndex = [(NSNumber *)obj integerValue];
        if (!(idx == sentinelCount) && (selectedIndex + 1) == [(NSNumber *)self.selectedIndexes[idx + 1] integerValue]) {
            [segmentSet addObject:[NSNumber numberWithInteger:selectedIndex]];
        }
    }];
    
    for (int i = 0; i < self.segmentSeperators.count; i++) {
        UIView *seperatorView = self.segmentSeperators[i];
        BOOL isIverted = [segmentSet containsObject:@(i)];
        if (isIverted && ![seperatorView.backgroundColor isEqual:self.backgroundColor]) {
            [UIView animateWithDuration:THSegmentedControlAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 seperatorView.backgroundColor = self.backgroundColor;
                             } completion:nil];
        } else if (!isIverted && ![seperatorView.backgroundColor isEqual:self.tintColor]) {
            [UIView animateWithDuration:THSegmentedControlAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 seperatorView.backgroundColor = self.tintColor;
                             } completion:nil];
        }
    }
}

#pragma mark - UIResponder Target Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

#pragma mark - UIAppearance Getters w/ Appearance Proxy

- (UIColor *)backgroundColor {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
    if(_backgroundColor == nil) {
        _backgroundColor = [[[self class] appearance] backgroundColor];
    }
#endif
    if(_backgroundColor != nil) {
        return _backgroundColor;
    }
    return [UIColor whiteColor];
}

- (UIColor *)tintColor {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
    if(_tintColor == nil) {
        _tintColor = [[[self class] appearance] tintColor];
    }
#endif
    if(_tintColor != nil) {
        return _tintColor;
    }
    return [UIColor colorWithRed:0.0f green:(122.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f];
}

- (UIFont *)font {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000
    if(_font == nil) {
        _font = [[[self class] appearance] font];
    }
#endif
    if(_font != nil) {
        return _font;
    }
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
}

#pragma mark - Tint Color Setter

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        self.layer.borderColor = tintColor.CGColor;
    }
}

#pragma mark - THMultipleSegmentSelectionDelegate

- (BOOL)allowSegment:(THSegmentedControlSegment *)segment
         toHighlight:(BOOL)highlighted
           withIndex:(NSInteger)index
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    if ([self.delegate respondsToSelector:@selector(allowSegmentWithIndex:toToggleAsSelected:)] && ![self.delegate allowSegmentWithIndex:index toToggleAsSelected:highlighted]) {
        return NO;
    }
    
    NSMutableOrderedSet *mutableSelectedIndexes = [self.selectedIndexes mutableCopy];
    if (highlighted) {
        [mutableSelectedIndexes addObject:@(index)];
    } else {
        [mutableSelectedIndexes removeObject:@(index)];
    }
    
    [mutableSelectedIndexes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *pos1 = (NSNumber *)obj1;
        NSNumber *pos2 = (NSNumber *)obj2;
        return (NSComparisonResult)[pos1 compare:pos2];
    }];
    self.selectedIndexes = [mutableSelectedIndexes copy];
    [self ensureProperSeperatorColor];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

@end

@interface THSegmentedControlSegment ()

@property (nonatomic, strong) UIGestureRecognizer *tapMan;
@property (nonatomic, strong) UILabel *textField;
@property (nonatomic) CGRect boundingPreTouchRect;
@property (nonatomic) BOOL preSelected;

@end

@implementation THSegmentedControlSegment

#pragma mark - THSegmentedControlSegment Init Methods

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index
{
    self = [self initWithFrame:frame];
    if (self) {
        self.index = index;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // Init
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.preSelected = NO;
    
    // Textfield init
    self.textField = [[UILabel alloc] initWithFrame:self.bounds];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.clipsToBounds = YES;
    self.textField.adjustsFontSizeToFitWidth = YES;
    self.textField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textField];
}

#pragma mark - UIView Callbacks

- (void)layoutSubviews
{
    [super layoutSubviews];
    // Creating the pretouch shading bounding hit rect on subview layout
    self.boundingPreTouchRect = CGRectMake(self.bounds.origin.x,
                                           self.bounds.origin.y - (3.0f * self.bounds.size.height),
                                           self.bounds.size.width,
                                           7.0f * self.bounds.size.height);
}

#pragma mark - Appearance Setters

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor
{
    NSLog(@"%@", segmentBackgroundColor);
    if (_segmentBackgroundColor != segmentBackgroundColor) {
        _segmentBackgroundColor = segmentBackgroundColor;
        if (self.selected) self.textField.textColor = segmentBackgroundColor;
    }
}

- (void)setSegmentHighlightedBackgroundColor:(UIColor *)segmentHighlightedBackgroundColor
{
    if (_segmentHighlightedBackgroundColor != segmentHighlightedBackgroundColor) {
        _segmentHighlightedBackgroundColor = segmentHighlightedBackgroundColor;
        if (!self.selected) self.textField.textColor = segmentHighlightedBackgroundColor;
    }
}

#pragma mark - Title and Font Setters for Textview

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        self.textField.text = title;
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        self.textField.font = font;
    }
}

#pragma mark - UIResponder Callbacks

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.preSelected = YES;
    [self changeSelectorToPreSelectionColor];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    if (CGRectContainsPoint(self.boundingPreTouchRect, [touch locationInView:self])) {
        self.preSelected = YES;
    } else {
        self.preSelected = NO;
    }
    [self changeSelectorToPreSelectionColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    if (CGRectContainsPoint(self.boundingPreTouchRect, [touch locationInView:self])) {
        if ([self.delegate allowSegment:self toHighlight:!self.selected withIndex:self.index]) self.selected = !self.selected;
    } else {
        [self changeSelectorToPreSelectionColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.preSelected = NO;
    UITouch *touch = [[touches allObjects] lastObject];
    if (CGRectContainsPoint(self.boundingPreTouchRect, [touch locationInView:self])) {
        if ([self.delegate allowSegment:self toHighlight:!self.selected withIndex:self.index]) self.selected = !self.selected;
    } else {
        [self changeSelectorToPreSelectionColor];
    }
}

#pragma mark - Appearance Animations and Appearance

- (void)changeSelectorToPreSelectionColor
{
    if (self.preSelected) {
        CGFloat fromAlpha = 0.0f;
        CGFloat toAlpha = 0.0f;
        CGFloat toRed = 0.0f;
        CGFloat toBlue = 0.0f;
        CGFloat toGreen = 0.0f;
        
        [self.segmentHighlightedBackgroundColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
        self.backgroundColor = [UIColor colorWithRed:toRed
                                               green:toGreen
                                                blue:toBlue
                                               alpha:(float)[self colorWithFromValue:fromAlpha toValue:toAlpha]];
//        self.textField.backgroundColor = [UIColor greenColor];
    } else {
        self.preSelected = NO;
        UIColor *toColor = self.selected ? self.segmentHighlightedBackgroundColor : self.backgroundColor;
        self.backgroundColor = toColor;
    }
}

- (CGFloat)colorWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CGFloat ratio = self.selected ? 0.5f : 0.2f;
    CGFloat diff = fromValue - toValue;
    CGFloat val = fromValue - (ratio * (float)diff);
    return val;
}

#pragma mark - Selected State

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self toggleHighlightAnimation:selected];
    }
}

- (void)toggleHighlightAnimation:(BOOL)highlighted
{
    NSLog(@"background color %@", self.segmentBackgroundColor);
    if (highlighted) {
        [UIView animateWithDuration:THSegmentedControlAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.textField.textColor = [UIColor whiteColor];
                             self.backgroundColor = self.segmentHighlightedBackgroundColor;
                         } completion:nil];
    } else {
        [UIView animateWithDuration:THSegmentedControlAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.backgroundColor = self.segmentBackgroundColor;
                             self.textField.textColor = self.segmentHighlightedBackgroundColor;
                         } completion:nil];
    }
}

@end

