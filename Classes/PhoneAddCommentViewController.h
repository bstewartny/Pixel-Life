//
//  PhoneAddCommentViewController.h
//  PixelLife
//
//  Created by Robert Stewart on 1/10/11.
//  Copyright 2011 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCommentViewController.h"

@interface PhoneAddCommentViewController : AddCommentViewController {
	BOOL _keyboardVisible;
	CGFloat _keyboardHeight;
}
- (void) doKeyboardWillShow:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration;
- (void) moveTextBoxesAboveKeyboard:(CGFloat)keyboardHeight;

@end
