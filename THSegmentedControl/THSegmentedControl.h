//
//  THMultipleSelectionSegmentedControl.h
//  THMultipleSelectionSegmentedControl
//
//  Created by Taylor Halliday on 11/20/13.
//  Copyright (c) 2013 5Celsius. All rights reserved.
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
*  @param items The array of segments. These are all assumed to be instances of NSSTring *
*
*  @return An instance of THSegmentedControl
*/
- (instancetype)initWithItems:(NSArray *)items;

///-------------------------------
/// @name Appearance Properties. All adhere to UIAppearance Proxies
///-------------------------------

/**
 Background color of unselected cells. The inverse of this color will be the font color within the cell.
 */
@property (readwrite, nonatomic, strong) UIColor *thSegmentedControlBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/**
 Background color of selected cells. The inverse of this color will be the font color within the cell.
 */
@property (readwrite, nonatomic, strong) UIColor *thSegmentedControlHighlightedBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

/**
 UIFont to be used withing cells
 */
@property (readwrite, nonatomic, strong) UIFont *thSegmentedControlSegmentTextFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;


///-------------------------------
/// @name Control State Properties
///-------------------------------

/**
 Control Selected Indexes
 */
@property (readonly, nonatomic, strong) NSOrderedSet *selectedIndexes;

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
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

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


