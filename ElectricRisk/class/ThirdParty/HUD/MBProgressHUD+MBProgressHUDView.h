//
//  MBProgressHUD+MBProgressHUDView.h
//  Botianxia
//
//  Created by CNEONLINE on 16/5/10.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (MBProgressHUDView)

/**
 * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
 * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
 * animations while appearing.
 *
 * @see animationType
 */
- (void)showByCustomView:(BOOL)animated;

- (void)showByCustomViewAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion;

/**
 * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
 * hide the HUD when your task completes.
 *
 * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
 * animations while disappearing.
 *
 * @see animationType
 */
- (void)hideByCustomView:(BOOL)animated;

@end
