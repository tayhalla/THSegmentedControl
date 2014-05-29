//
//  THMultipleSelectionSegmentedControl.h
//  THMultipleSelectionSegmentedControl
//
//  Created by Taylor Halliday on 11/20/13.
//  Copyright (c) 2013 5Celsius. All rights reserved.
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

#import <UIKit/UIKit.h>

///-------------------------------
/// @name THSegmentedControl Delegate Protocol
///-------------------------------

@protocol THSegmentedControlDelegate <NSObject>

@optional

/**
 *  Delegate callback that optionally allows the delegate to decide whether or not to
 *  allow the control to show the tapped item as selected.
 *
 *  @param index                  The index of the tapped index
 *  @param requestedSelectedState The proposed state of the segment
 *
 *  @return Boolean value indicating YES for ok to proceed, and NO for ignore.
 */

- (BOOL)allowSegmentWithIndex:(NSInteger)index toToggleAsSelected:(BOOL)requestedSelectedState;

@end


/**
 `THSegmentedControl` creates and returns a UIControl subclass that closely resembles the stock UISegmentedControl, but adds
 support for allowing multiple segment selection.
 
 TODO:
 - Add support for using images
 */

@interface THSegmentedControl : UIControl

///---------------------
/// @name Initialization
///---------------------

/**
 *  Creates and returns an instance of THSegmentedControl with the provides segments
 *
 *  @param segments The array of segments. These are all assumed to be instances of NSSTring *
 *
 *  @return An instance of THSegmentedControl
 */
- (instancetype)initWithSegments:(NSArray *)segments;

///-------------------------------
/// @name Appearance Properties. All adhere to UIAppearance Proxies
///-------------------------------

/**
 Background color of unselected cells. The inverse of this color will be the font color within the cell.
 */
@property (readwrite, nonatomic, strong) UIColor *backgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/**
 Background color of selected cells. The inverse of this color will be the font color within the cell.
 */
@property (readwrite, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/**
 UIFont to be used withing cells
 */
@property (readwrite, nonatomic, strong) UIFont *font NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;


///-------------------------------
/// @name Control State Properties
///-------------------------------

/**
 *  Sets the selected indexes
 *
 *  @param selectedIndexes NSOrderedSet of selected indexes
 */
- (void)setSelectedIndexes:(NSOrderedSet *)selectedIndexes;

/**
 *  Returns the index set of the currently selected indexes
 *
 *  @return Selected indexes
 */
- (NSOrderedSet *)selectedIndexes;

///-------------------------------
/// @name THSegmentedControl Delegate
///-------------------------------

@property (nonatomic, weak) id <THSegmentedControlDelegate> delegate;

///-------------------------------
/// @name Getter / Setter Methods for segments and their values
///-------------------------------

/**
 *  Set control segments by index with title. If the segments are not sequentually loaded,
 *  a blank string (@"") will take the missing segments' place. Will not throw an exception for
 *  placing segments out of sequence.
 *
 *  @param title   Title of the segment to be set
 *  @param segment Index location of the segment to be set
 */
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment;

/**
 *  Receive array of titles for segments.
 *
 *  @param Indexes An ordered set of indexes
 *
 *  @return An array of titles for the segments provided, while maintaining order
 */
- (NSArray *)titlesForSegmentsAtIndexes:(NSOrderedSet *)indexes;

/**
 Receive the title of a segment for a specified index
 */

/**
 *  Returns the NSString title for a given index
 *
 *  @param index Index of the requested title
 *
 *  @return The NSString title cooresponding to the index.
 */
- (NSString *)titleForSegmentAtIndex:(NSInteger)index;

/**
 *  Returns the number of segments in the control
 *
 *  @return Number of segments
 */
- (NSInteger)numberOfSegments;

/**
 *  Removes the segments at the provided index.
 *
 *  @param index Index of item to be removed
 */
- (void)removeSegmentsAtIndex:(NSInteger)index;

/**
 *  Removes all the segments
 */
- (void)removeAllSegments;

@end


