//
//  MAKTextView.m
//  iMemoriesCore Data
//
//  Created by Lion Boney on 2/21/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
//

#import "MAKTextView.h"

@implementation MAKTextView
@synthesize name;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBorderWidth:0.5f];
    [self.layer setCornerRadius:5.0f];
    [self setBackgroundColor:[UIColor whiteColor]];
}


@end
