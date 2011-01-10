//
//  PhoneAddCommentViewController.m
//  PixelLife
//
//  Created by Robert Stewart on 1/10/11.
//  Copyright 2011 Evernote. All rights reserved.
//

#import "PhoneAddCommentViewController.h"


@implementation PhoneAddCommentViewController


- (void)keyboardWillShow:(NSNotification *)notification {
    
	/*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
	 */
	
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
	
	// depending on what orientation we are, we need either height or width of keyboard
	CGFloat keyboardHeight = keyboardRect.size.height;
	
	CGFloat min_width=MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
	
	// assume we are in other orientation
	if(keyboardHeight >= min_width)
	{
		keyboardHeight=keyboardRect.size.width;
	}
	
	_keyboardHeight=keyboardHeight;
	
	// Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
	[self doKeyboardWillShow:keyboardHeight animationDuration:animationDuration];
	
	_keyboardVisible=YES;
}

- (void) doKeyboardWillShow:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration
{
	// animate in sync with keyboard animation
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
	[self moveTextBoxesAboveKeyboard:keyboardHeight];
	
    [UIView commitAnimations];
}

- (void) moveTextBoxesAboveKeyboard:(CGFloat)keyboardHeight
{
	CGRect newTextViewFrame = self.messageTextView.frame;
    newTextViewFrame.size.height = (self.view.bounds.size.height - 44) - keyboardHeight;
	self.messageTextView.frame=newTextViewFrame;
}

- (void)keyboardWillHide:(NSNotification *)notification 
{
	NSDictionary* userInfo = [notification userInfo];
    
	// animate in sync with keyboard animation
	NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
	[self doKeyboardWillHide:animationDuration];
	
	_keyboardVisible=NO;
}

- (void) doKeyboardWillHide:(NSTimeInterval)animationDuration
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self setTextViewFrames];
	[UIView commitAnimations];
}

- (void) setTextViewFrames
{
	CGRect f=messageTextView.frame;
	f.size.height=(self.view.bounds.size.height - 44);
	messageTextView.frame=f;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if(_keyboardVisible)
	{
		[self setTextViewFrames];
		
		[UIView beginAnimations:nil context:NULL];
		
		[self moveTextBoxesAboveKeyboard:_keyboardHeight];
		
		[UIView commitAnimations];
		
		
		[self moveTextBoxesAboveKeyboard:_keyboardHeight];
	}
	else 
	{
		[self setTextViewFrames];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
	
	//[picture release];
    [super dealloc];
}

@end
