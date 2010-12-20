//
//  AddCommentTableViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/18/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddCommentTableViewCell : UITableViewCell<UITextViewDelegate> {
	IBOutlet UITextView * messageTextView;
	CGRect origFrame;
}
@property(nonatomic,retain) IBOutlet UITextView * messageTextView;

- (IBAction) addButtonTouch:(id)sender;
- (IBAction) sendMessage:(id)sender;
- (void) load;
@end
