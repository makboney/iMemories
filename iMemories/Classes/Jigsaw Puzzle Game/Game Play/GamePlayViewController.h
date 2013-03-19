//
//  GamePlayViewController.h
//  iMemories
//
//  Created by Boney's Macmini on 1/8/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
//

#define kPuzzleSize				320
#define kPieceSize				96

#define kPuzzleSizeiPad				676
#define kPieceSizeiPad				202.8

#define kNumPieces				5
#define kPieceDistance          (kPuzzleSize / kNumPieces)
#define kPieceDistanceiPad		(kPuzzleSizeiPad / kNumPieces)

#define kPieceShadowFactor		4
#define kPieceShadowOpacity		0.5
#define kPieceShadowOffset		1
#define kPieceGrabOffset		3
#define kPieceListMargin		20
#define kTransitionDuration		0.75

#import <UIKit/UIKit.h>
#import "BackgroundView.h"
#import "JigsawDelegate.h"
#import "PieceView.h"
//#import "MyMusicPlayer.h"

@interface GamePlayViewController : UIViewController<JigsawDelegate>{

    UIView *_puzzleView;
    UIScrollView *_scrollView;
    BackgroundView * _backgroundView;
    PieceView*			_pieces[kNumPieces * kNumPieces];
    UIImageView *_imageView;
    CGFloat _puzzleRotation;
	BOOL _completed;
    BOOL _didMove;
	NSMutableArray *_puzzles;
    
    CGPoint _startLocation,_startPosition;
}
@property (nonatomic, retain) UIImage *puzzleImage;
@end
