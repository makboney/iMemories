//
//  MAKControlView.m
//  iMemoriesCore Data
//
//  Created by Lion Boney on 2/22/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
//

#import "MAKControlView.h"

@implementation MAKControlView

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
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.75f;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.957 alpha:1.000] CGColor], (id)[[UIColor colorWithWhite:0.808 alpha:1.000] CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}


@end
