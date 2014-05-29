//
//  THBaseViewController.m
//  THSegmentedControl
//
//  Created by Taylor Halliday on 1/15/14.
//  Copyright (c) 2014 5Celsus. All rights reserved.
//

#import "THBaseViewController.h"
#import "THSegmentedControl.h"

@interface THBaseViewController ()

@property (nonatomic, strong) UISegmentedControl *baseControl;
@property (nonatomic, strong) UILabel *baseLabel;

@property (nonatomic, strong) THSegmentedControl *thControl;
@property (nonatomic, strong) UILabel *thLabel;

@end

@implementation THBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSegments];
    [self initLabels];
}

- (void)initSegments
{
    // Init the Segmented Controls
    
    CGFloat controlWidth            = self.view.bounds.size.width * 4.0f / 5.0f;
    CGFloat controlHeight           = 50.0f;
    
    NSArray *segments = @[@"White", @"Black", @"Gold"];
    
    self.baseControl = ({
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:segments];
        CGRect frame = CGRectMake((self.view.bounds.size.width - controlWidth) / 2.0f,
                                  (self.view.bounds.size.height / 4.0f),
                                  controlWidth,
                                  controlHeight);
        [segControl setFrame:frame];
        segControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [segControl addTarget:self action:@selector(baseControlChangedSegment:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchDown | UIControlEventAllTouchEvents];
        segControl;
    });
    
    self.thControl = ({
        THSegmentedControl *thControl = [[THSegmentedControl alloc] initWithSegments:segments];
        CGRect frame = CGRectMake((self.view.bounds.size.width - controlWidth) / 2.0f,
                                  (self.view.bounds.size.height * 1.8f / 4.0f),
                                  controlWidth,
                                  controlHeight);
        [thControl setFrame:frame];
        thControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [thControl addTarget:self action:@selector(thControlChangedSegment:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchUpInside];
        [thControl setTintColor:[UIColor greenColor]];
        thControl;
    });
    
    [self.view addSubview:self.baseControl];
    [self.view addSubview:self.thControl];
}

- (void)initLabels
{
    // Init the labels
    NSString *defaultText = @"No Selection Has Been Made";
    
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    CGFloat labelHeight = 50.0f;
    CGFloat labelHorizInset = 10.0f;
    
    UILabel *titleLabel = ({
        CGRect segmentedFrame = self.baseControl.frame;
        CGRect frame = CGRectMake(self.view.bounds.origin.x,
                                  segmentedFrame.origin.y - labelHeight - 60.0f,
                                  self.view.bounds.size.width,
                                  labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"What is the best iPhone color?"];
        NSInteger strCount = [string length];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(strCount - 1, 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(strCount - 2, 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(strCount - 3, 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(strCount - 4, 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(strCount - 5, 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(strCount - 6, 1)];
        
        label.attributedText = string;
        label.font = [UIFont boldSystemFontOfSize:18.0f];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        label;
    });
    
    self.baseLabel = ({
        CGRect segmentedFrame = self.baseControl.frame;
        CGRect frame = CGRectMake(self.view.bounds.origin.x + labelHorizInset,
                                  segmentedFrame.origin.y - labelHeight + 10.0f,
                                  self.view.bounds.size.width - (2.0f * labelHorizInset),
                                  labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = defaultText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:labelFont.familyName size:12]];
        [label setNumberOfLines:2];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        label;
    });
    
    self.thLabel = ({
        CGRect segmentedFrame = self.thControl.frame;
        CGRect frame = CGRectMake(self.view.bounds.origin.x + labelHorizInset,
                                  segmentedFrame.origin.y - labelHeight + 10.0f,
                                  self.view.bounds.size.width - (2.0f * labelHorizInset),
                                  labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = defaultText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:labelFont.familyName size:12]];
        [label setNumberOfLines:2];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        label;
    });

    [self.view addSubview:titleLabel];
    [self.view addSubview:self.baseLabel];
    [self.view addSubview:self.thLabel];
}

#pragma mark - Target Action

// Base Segmented Control Target
- (void)baseControlChangedSegment:(UISegmentedControl *)baseSegmentedControl
{
    NSInteger selectedSegmentIndex = baseSegmentedControl.selectedSegmentIndex;
    if (selectedSegmentIndex > -1) {
        NSString *labelText = [NSString stringWithFormat:@"UISegmentedControl Says That The Best iPhone Color is %@", [baseSegmentedControl titleForSegmentAtIndex:selectedSegmentIndex]];
        self.baseLabel.text = labelText;
    }
}

// THSegmented Control Target
- (void)thControlChangedSegment:(THSegmentedControl *)thSegmentedControl
{
    NSOrderedSet *orderedIndexes = thSegmentedControl.selectedIndexes;
    if (orderedIndexes.count > 1) {
        NSString *title = @"THSegmentedControl Says That Your Favorite iPhone Colors are";
        for (int i = 0; i < orderedIndexes.count; i++) {
            NSInteger index = [[orderedIndexes objectAtIndex:i] integerValue];
            if (i == (orderedIndexes.count - 1)) {
                title = [title stringByAppendingString:[NSString stringWithFormat:@" and %@!", [thSegmentedControl titleForSegmentAtIndex:index]]];
            } else {
                if (orderedIndexes.count == 2) {
                    title = [title stringByAppendingString:[NSString stringWithFormat:@" %@", [thSegmentedControl titleForSegmentAtIndex:index]]];
                } else {
                    title = [title stringByAppendingString:[NSString stringWithFormat:@" %@,", [thSegmentedControl titleForSegmentAtIndex:index]]];
                }
            }
        }
        self.thLabel.text = title;
    } else if (orderedIndexes.count == 1) {
        self.thLabel.text = [NSString stringWithFormat:@"THSegmentedControl Says That The Best iPhone Color is %@!", [thSegmentedControl titleForSegmentAtIndex:[orderedIndexes.lastObject integerValue]]];
    } else {
        self.thLabel.text = @"You Don't Have A Favorite iPhone Color... :(";
    }
}

@end
