//
//  AboutViewController.h
//  PixelLife
//
//  Created by Robert Stewart on 3/6/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
	 
	IBOutlet UITableView * tableView;
	
}
 @property(nonatomic,retain) IBOutlet UITableView * tableView;

- (IBAction) done;

@end
