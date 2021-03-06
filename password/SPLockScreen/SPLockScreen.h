//
//  SPLockScreen.h
//  SuQian
//
//  Created by Suraj on 24/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPLockScreen;

@protocol LockScreenDelegate <NSObject>
- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber;
@end


@interface SPLockScreen : UIView

@property (nonatomic, strong) id<LockScreenDelegate> delegate;
// Set to YES to allow a closed pattern, a complex type pattern; NO by default
@property (nonatomic) BOOL allowClosedPattern;

// Init Method
- (id)initWithDelegate:(id<LockScreenDelegate>)lockDelegate;

@end
