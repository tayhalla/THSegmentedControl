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
    [self initSegments];
    [self initLabels];
}

- (void)initSegments
{
    // Init the Segmented Controls
    
    CGFloat controlWidth            = self.view.bounds.size.width / 2.0f;
    CGFloat controlHeight           = 50.0f;
    CGFloat controlMidVertOffset = 100.0f;
    
    NSArray *segments = @[@"First", @"Second", @"Third", @"Fourth"];
    
    self.baseControl = ({
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:segments];
        CGRect frame = CGRectMake(self.view.bounds.size.width - (controlWidth / 2.0f),
                                  (self.view.bounds.size.height / 2.0f) - controlMidVertOffset,
                                  controlWidth,
                                  controlHeight);
        [segControl addTarget:self action:@selector(baseControlChangedSegment:) forControlEvents:UIControlEventTouchUpInside];
        [segControl setFrame:frame];
        segControl;
    });
    
    self.thControl = ({
        THSegmentedControl *thControl = [[THSegmentedControl alloc] initWithItems:segments];
        CGRect frame = CGRectMake(self.view.bounds.size.width + (controlWidth / 2.0f),
                                  (self.view.bounds.size.height / 2.0f) - controlMidVertOffset,
                                  controlWidth,
                                  controlHeight);
        [thControl setFrame:frame];
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
    
    CGFloat labelHeight     = 50.0f;
    CGFloat labelVertOffset = -10.0f;
    
    self.baseLabel = ({
        CGRect segmentedFrame = self.baseControl.frame;
        CGRect frame = CGRectMake(segmentedFrame.origin.x,
                                  segmentedFrame.origin.y - labelVertOffset - labelHeight,
                                  segmentedFrame.size.width,
                                  labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = defaultText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:labelFont];
        label;
    });
    
    self.thLabel = ({
        CGRect segmentedFrame = self.thControl.frame;
        CGRect frame = CGRectMake(segmentedFrame.origin.x,
                                  segmentedFrame.origin.y - labelVertOffset - labelHeight,
                                  segmentedFrame.size.width,
                                  labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = defaultText;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:labelFont];
        label;
    });
    
    [self.view addSubview:self.baseLabel];
    [self.view addSubview:self.thLabel];
}

#pragma mark - Target Action

// Base Segmented Control Target
- (void)baseControlChangedSegment:(UISegmentedControl *)baseSegmentedControl
{
    
    NSString *labelText = [NSString stringWithFormat:@""]
    
}

// THSegmented Control Target
- (void)thControlChangedSegment:(THSegmentedControl *)thSegmentedControl
{
    
}


@end
