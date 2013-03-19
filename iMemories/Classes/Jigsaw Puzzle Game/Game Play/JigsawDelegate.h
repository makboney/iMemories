//
//  JigsawDelegate.h
//  JigsawPuzzle
//
//  Created by Macmini2 on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define kPieceGrabOffset		3

#import <Foundation/Foundation.h>
//#import "PieceView.h"

@protocol JigsawDelegate <NSObject>
-(void)resetPiece:(UIView*)piece;
- (void) beginTrackingPiece:(UIView*)piece position:(CGPoint)position;
- (void) continueTrackingPiece:(UIView*)piece position:(CGPoint)position;
//- (void) endTrackingPiece:(UIView*)piece position:(CGPoint)position andIsoriented:(BOOL)isPieceOriented;
- (void) endTrackingPiece:(UIView*)piece position:(CGPoint)position;
- (void) willAnimateFirstHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation;
- (void) willAnimateSecondHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation;
- (void)doubleTapBackground;
@end
