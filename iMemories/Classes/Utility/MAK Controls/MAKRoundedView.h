//
//  MAKRoundedView.h
//  MAKRND
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 Lion Boney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface MAKRoundedView : UIView
{

    CGFloat _cornerRadius;
}
- (id) initWithCornerRadius:(float)cornerRadius;
@end
