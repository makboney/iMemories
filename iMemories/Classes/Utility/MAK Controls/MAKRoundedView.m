//
//  MAKRoundedView.m
//  MAKRND
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 Lion Boney. All rights reserved.
//

#import "MAKRoundedView.h"

@implementation MAKRoundedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithCornerRadius:(float)cornerRadius{

    if ([super init]) {
        // Initialization code
        _cornerRadius = cornerRadius;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}


@end
