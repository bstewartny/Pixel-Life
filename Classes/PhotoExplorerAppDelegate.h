//
//  PhotoExplorerAppDelegate.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Facebook;

@class PhotoExplorerViewController;

@interface PhotoExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	UINavigationController * navController;
	UISegmentedControl * segmentedControl;
	Facebook * facebook;
}
@property (nonatomic, retain) NSOperationQueue *downloadQueue;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController * navController;
@property(nonatomic,retain) Facebook * facebook;

+ (PhotoExplorerAppDelegate*) sharedAppDelegate;


@end

