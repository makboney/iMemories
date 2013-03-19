//
//  GamePlayViewController.m
//  iMemories
//
//  Created by Boney's Macmini on 1/8/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
//

#import "GamePlayViewController.h"
//MACROS:

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__) - (__MIN__)))

@interface GamePlayViewController ()
- (void)_resetPuzzle;
- (void) _updatePieceList;
@end
//VARIABLES:

static const CGFloat _OrientationAngles[] = {NAN, 0, 180, 90, 270, NAN, NAN};

//FUNCTIONS:

static CGAffineTransform _MakeRoundedRotationTransform(CGFloat angle)
{
	CGAffineTransform		transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
    
	//We need to "fix" the matrix to ensure it's a perfect rotation matrix if "angle" is a multiple of 90 degrees
	transform.a = roundf(transform.a);
    transform.b = roundf(transform.b);
    transform.c = roundf(transform.c);
    transform.d = roundf(transform.d);
	
	return transform;
}
@implementation GamePlayViewController
@synthesize puzzleImage = _puzzleImage;
#pragma mark - View Life Cycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect rect = [[UIScreen mainScreen] bounds];
    //Create the background transition view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _backgroundView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSizeiPad, kPuzzleSizeiPad)];
    }else _backgroundView = [[BackgroundView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSize, kPuzzleSize)];
    [_backgroundView setDelegate:self];
	[_backgroundView setImage:[UIImage imageNamed:@"Puzzle-Background.png"]];
	[_backgroundView setOpaque:YES];
    [_backgroundView setUserInteractionEnabled:YES];
	[self.view addSubview:_backgroundView];
    
    //Create the puzzle view and add it to the background view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {    
        _puzzleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSizeiPad, kPuzzleSizeiPad)];
    }else _puzzleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSize, kPuzzleSize)];
	[_backgroundView addSubview:_puzzleView];
    
    //Create the scrollview for the pieces and add it to the window
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPuzzleSizeiPad, rect.size.width, rect.size.height - kPuzzleSizeiPad)];
    }
	else {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPuzzleSize, rect.size.width, rect.size.height - kPuzzleSize)];               
    }
    //[_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pieces-Background.png"]]];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
	[_scrollView setCanCancelContentTouches:NO];
	[_scrollView setClipsToBounds:NO];
	[self.view addSubview:_scrollView];
    
    //Reset the puzzle but with a delay to avoid blocking the UI while the app is still loading
	[self performSelector:@selector(_resetPuzzle) withObject:nil afterDelay:0.1];
}



#pragma mark - Class Method
- (void) _resetPuzzle
{
	NSUInteger				indices[kNumPieces * kNumPieces];
	NSUInteger				index,
    swap,
    i;
	UIImageView*			imageView;
	CGImageRef				image;
	CGImageRef				subImage;
	CGDataProviderRef		provider;
	CGContextRef			context;
	CGColorSpaceRef			imageColorSpace;
	CGColorSpaceRef			maskColorSpace;
	CGImageRef				mask;
	CGImageRef				tile;
	CGImageRef				shadow;
	//NSString*				path;
	CGAffineTransform		transform;
	
	//Reset puzzle state
	_completed = NO;
	
	//Pick a random puzzle orientation (1 out of 4 possibilities)
	_puzzleRotation = roundf(RANDOM_INT(0, 3) * 90.0);
	
	//Create our colorspaces
	imageColorSpace = CGColorSpaceCreateDeviceRGB();
	maskColorSpace = CGColorSpaceCreateDeviceGray();
	
	//Load a random puzzle image
	/*path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Puzzles"];
    NSLog(@"path %@",path);
	if(![_puzzles count])
        [_puzzles release];
	
	_puzzles = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] mutableCopy];
	index = RANDOM_INT(0, [_puzzles count] - 1);
	provider = CGDataProviderCreateWithFilename([[path stringByAppendingPathComponent:[_puzzles objectAtIndex:index]] UTF8String]);
	image = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(provider);
	[_puzzles removeObjectAtIndex:index];
	*/
    image = [_puzzleImage CGImage];
	//Resize the puzzle image
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {        
        context = CGBitmapContextCreate(NULL, kPuzzleSizeiPad, kPuzzleSizeiPad, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(context, CGRectMake(0, 0, kPuzzleSizeiPad, kPuzzleSizeiPad), image);
    }else{    
        context = CGBitmapContextCreate(NULL, kPuzzleSize, kPuzzleSize, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(context, CGRectMake(0, 0, kPuzzleSize, kPuzzleSize), image);
    }
	
	CGImageRelease(image);
	image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	//Create the image view with the puzzle image
	[_imageView release];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSizeiPad, kPuzzleSizeiPad)];
    }else{
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPuzzleSize, kPuzzleSize)];
    }
	[_imageView setImage:[UIImage imageWithCGImage:image]];
	
	//Create the puzzle pieces (note that pieces are rotated to the puzzle orientation in order to minimize the number of graphic operations when creating the puzzle images)
	transform = _MakeRoundedRotationTransform(_puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		//Recreate the piece view
		[_pieces[i] removeFromSuperview];
		[_pieces[i] release];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _pieces[i] = [[PieceView alloc] initWithFrame:CGRectMake(0, 0, kPieceSizeiPad, kPieceSizeiPad) index:i];
        }else{
        
            _pieces[i] = [[PieceView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize) index:i];
        }
        [_pieces[i] setDelegate:self];
		[_pieces[i] setTransform:transform];
		[_pieces[i] setTag:-1];
		
		//Adjust the puzzle piece index according to puzzle orientation
		if((_puzzleRotation == 0) || (_puzzleRotation == 180))
            index = i;
		else
            index = kNumPieces - 1 - (i / kNumPieces) + (i % kNumPieces) * kNumPieces;
		if((_puzzleRotation == 180) || (_puzzleRotation == 90))
            index = kNumPieces * kNumPieces - 1 - index;
		
		//Load puzzle piece mask image
		provider = CGDataProviderCreateWithFilename([[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02i", index + 1] ofType:@"png"] UTF8String]);
		tile = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
		CGDataProviderRelease(provider);
		mask = CGImageCreateCopyWithColorSpace(tile, maskColorSpace);
		CGImageRelease(tile);
		
		//Create image view with a low-resolution piece shadow image (to make it look blurred) and add it to the piece view
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            context = CGBitmapContextCreate(NULL, kPieceSizeiPad / kPieceShadowFactor, kPieceSizeiPad / kPieceShadowFactor, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
            CGContextClipToMask(context, CGRectMake(0, 0, kPieceSizeiPad / kPieceShadowFactor, kPieceSizeiPad / kPieceShadowFactor), mask);
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextFillRect(context, CGRectMake(0, 0, kPieceSizeiPad / kPieceShadowFactor, kPieceSizeiPad / kPieceShadowFactor));
            shadow = CGBitmapContextCreateImage(context);
            CGContextRelease(context);
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSizeiPad, kPieceSizeiPad)];
        }else{
            context = CGBitmapContextCreate(NULL, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
            CGContextClipToMask(context, CGRectMake(0, 0, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor), mask);
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
            CGContextFillRect(context, CGRectMake(0, 0, kPieceSize / kPieceShadowFactor, kPieceSize / kPieceShadowFactor));
            shadow = CGBitmapContextCreateImage(context);
            CGContextRelease(context);
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize)];
        }
		
		[imageView setImage:[UIImage imageWithCGImage:shadow]];
		[imageView setAlpha:kPieceShadowOpacity];
		[imageView setUserInteractionEnabled:NO];
		[_pieces[i] addSubview:imageView];
		[imageView release];
		CGImageRelease(shadow);
		
		//Create image view with piece image and add it to the piece view
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            context = CGBitmapContextCreate(NULL, kPieceSizeiPad, kPieceSizeiPad, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
        }else{
        
            context = CGBitmapContextCreate(NULL, kPieceSize, kPieceSize, 8, 0, imageColorSpace, kCGImageAlphaPremultipliedFirst);
        }
		if(_puzzleRotation) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                CGContextTranslateCTM(context, kPieceSizeiPad / 2, kPieceSizeiPad / 2);
            }else {
                CGContextTranslateCTM(context, kPieceSize / 2, kPieceSize / 2);
            }
			
			CGContextRotateCTM(context, DEGREES_TO_RADIANS(_puzzleRotation));
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                CGContextTranslateCTM(context, -kPieceSizeiPad / 2, -kPieceSizeiPad / 2);
            }else {
                CGContextTranslateCTM(context, -kPieceSize / 2, -kPieceSize / 2);
            }
		}
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            CGContextTranslateCTM(context, (kPieceSizeiPad - kPieceDistanceiPad) / 2 - fmodf(i, kNumPieces) * kPieceDistanceiPad, (kPieceSizeiPad - kPieceDistanceiPad) / 2 - (kNumPieces - 1 - floorf(i / kNumPieces)) * kPieceDistanceiPad);
        }else {
            CGContextTranslateCTM(context, (kPieceSize - kPieceDistance) / 2 - fmodf(i, kNumPieces) * kPieceDistance, (kPieceSize - kPieceDistance) / 2 - (kNumPieces - 1 - floorf(i / kNumPieces)) * kPieceDistance);
        }
		
		CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
		subImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		tile = CGImageCreateWithMask(subImage, mask);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSizeiPad, kPieceSizeiPad)];
        }else{
        
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPieceSize, kPieceSize)];
        }
		
		[imageView setImage:[UIImage imageWithCGImage:tile]];
		[imageView setUserInteractionEnabled:NO];
		[_pieces[i] addSubview:imageView];
		[imageView release];
		CGImageRelease(tile);
		CGImageRelease(subImage);
		
		//Release puzzle piece mask
		CGImageRelease(mask);
		
		//Make sure the shadow is setup correctly
		[_pieces[i] updateShadow:NO forRotation:_puzzleRotation];
	}
	
	//Clean up
	CGColorSpaceRelease(maskColorSpace);
	CGColorSpaceRelease(imageColorSpace);
	CGImageRelease(image);
	
	//Randomize pieces order
	for(i = 0; i < kNumPieces * kNumPieces; ++i)
        indices[i] = i;
	for(i = 0; i < 256; ++i) {
		index = RANDOM_INT(0, kNumPieces * kNumPieces - 1);
		swap = indices[index];
		indices[index] = indices[0];
		indices[0] = swap;
	}
	
	//Add all pieces to the scrollview
	for(i = 0; i < kNumPieces * kNumPieces; ++i)
        [_scrollView addSubview:_pieces[indices[i]]];
	[self _updatePieceList];
	
	//Play start sound
	//[_startSound play];
}
- (void) _updatePieceList
{
	CGSize					size = [_scrollView bounds].size;
	NSArray*				subviews = [_scrollView subviews];
	NSUInteger				count = 0;
	PieceView*				view;
	
	//Reposition and count all pieces currently in scrollview
	for(view in subviews)
        if([view isKindOfClass:[PieceView class]]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [view setCenter:CGPointMake(kPieceListMargin / 2 + kPieceSizeiPad / 2 + count * (kPieceSizeiPad + kPieceListMargin), size.height / 2)];
                
            }else{
                [view setCenter:CGPointMake(kPieceListMargin / 2 + kPieceSize / 2 + count * (kPieceSize + kPieceListMargin), size.height / 2)];
                
            }
            ++count;
        }
	
	//Update the scrollview dimensions
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(count * (kPieceSizeiPad + kPieceListMargin) > size.width) {
            [_scrollView setContentSize:CGSizeMake(count * (kPieceSizeiPad + kPieceListMargin), size.height)];
            [_scrollView setScrollEnabled:YES];
        }
        else {
            [_scrollView setContentSize:size];
            [_scrollView setScrollEnabled:NO];
        }
    }else{
        if(count * (kPieceSize + kPieceListMargin) > size.width) {
            [_scrollView setContentSize:CGSizeMake(count * (kPieceSize + kPieceListMargin), size.height)];
            [_scrollView setScrollEnabled:YES];
        }
        else {
            [_scrollView setContentSize:size];
            [_scrollView setScrollEnabled:NO];
        }
    }
	
	
}

#pragma mark - Jigsaw Delegate
- (void) doubleTapBackground
{
	//If the puzzle is completed, start a new one
	if(_completed)
        [self performSelector:@selector(_resetPuzzle) withObject:nil afterDelay:0.0];
	//Otherwise, toggle the visibility of the final image
	else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationTransition:([_imageView superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:_backgroundView cache:YES];
		if([_imageView superview]) {
			[_imageView removeFromSuperview];
			[_backgroundView addSubview:_puzzleView];
		}
		else {
			[_puzzleView removeFromSuperview];
			[_backgroundView addSubview:_imageView];
		}
		[UIView commitAnimations];
	}
}

- (void) resetPiece:(PieceView*)piece
{
	CGFloat					angle = [self interfaceOrientation];
    
	//If the piece is not in the scrollview, put it back there
	if([piece superview] != _scrollView) {
		//Move the piece from puzzle view to scrollview
		[piece setTag:-1];
		[piece removeFromSuperview];
		[piece setTransform:_MakeRoundedRotationTransform(angle + _puzzleRotation)];
		[piece setCenter:[_scrollView convertPoint:[piece center] fromView:_puzzleView]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [_scrollView insertSubview:piece atIndex:MIN(ceilf([_scrollView contentOffset].x / (kPieceSizeiPad + kPieceListMargin)), [[_scrollView subviews] count])];
        }else{
        
            [_scrollView insertSubview:piece atIndex:MIN(ceilf([_scrollView contentOffset].x / (kPieceSize + kPieceListMargin)), [[_scrollView subviews] count])];
        }
		
		
		//Update pieces in scrollview
		[UIView beginAnimations:nil context:NULL];
		[self _updatePieceList];
		[UIView commitAnimations];
		
		//Play sound
		//[[MyMusicPlayer musicPlayer] playDragSound];
	}
}

- (void) beginTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	//Save initial position and prepare tracking
	_startLocation = [[piece superview] convertPoint:position fromView:piece];
	_startPosition = [piece center];
	[[piece superview] bringSubviewToFront:piece];
	_didMove = NO;
	
	//Update shadow
	[piece updateShadow:YES forRotation:_puzzleRotation];
	
	//Reset position tag
	[piece setTag:-1];
}

- (void) continueTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	CGPoint					location = [[piece superview] convertPoint:position fromView:piece];
	CGRect					bounds;
	
	//Update piece position
	location.x = _startPosition.x + location.x - _startLocation.x;
	location.y = _startPosition.y + location.y - _startLocation.y;
	
	//Make sure piece stays inside puzzle view
	if([piece superview] == _puzzleView) {
		bounds = [_puzzleView bounds];
		location.x = MIN(MAX(bounds.origin.x, location.x), bounds.origin.x + bounds.size.width);
		location.y = MIN(MAX(bounds.origin.y, location.y), bounds.origin.y + bounds.size.height);
	}
	
	//Move piece
	[piece setCenter:location];
	
	//Play sound
	//if((_didMove == NO) && ([piece superview] != _puzzleView))
        //[[MyMusicPlayer musicPlayer] playDragSound];
	_didMove = YES;
}

- (void) endTrackingPiece:(PieceView*)piece position:(CGPoint)position
{
	BOOL					snap = NO;
	CGPoint					snapPosition;
	NSInteger				index;
	NSUInteger				i;
	
	//Make sure the piece has actually moved
	if(_didMove) {
		//If the piece is in the scrollview, check if if needs to be moved out of it into the puzzle view or if it needs to slide back into place
		if([piece superview] != _puzzleView) {
			if([_imageView superview] || CGRectContainsPoint([_scrollView bounds], [[piece superview] convertPoint:position fromView:piece])) {
				[UIView beginAnimations:nil context:NULL];
				[piece setCenter:_startPosition];
				[UIView commitAnimations];
				
                //Play sound
				//[[MyMusicPlayer musicPlayer] playDragSound];
			}
			else {
				[piece removeFromSuperview];
				[piece setTransform:_MakeRoundedRotationTransform(_puzzleRotation)];
				[piece setCenter:[_puzzleView convertPoint:[piece center] fromView:_scrollView]];
				[_puzzleView addSubview:piece];
				
				[UIView beginAnimations:nil context:NULL];
				[self _updatePieceList];
				[UIView commitAnimations];
			}
		}
		
		//If the piece is in the puzzle view, check if it can "snap" into a known piece position
		if([piece superview] == _puzzleView) {
			position = [piece center];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                snapPosition.x = MIN(MAX(roundf((position.x - kPieceDistanceiPad / 2) / kPieceDistanceiPad), 0), kNumPieces - 1);
                snapPosition.y = MIN(MAX(roundf((position.y - kPieceDistanceiPad / 2) / kPieceDistanceiPad), 0), kNumPieces - 1);
                index = snapPosition.y * kNumPieces + snapPosition.x;
                snapPosition.x = snapPosition.x * kPieceDistanceiPad + kPieceDistanceiPad / 2;
                snapPosition.y = snapPosition.y * kPieceDistanceiPad + kPieceDistanceiPad / 2;
            }else{
            
                snapPosition.x = MIN(MAX(roundf((position.x - kPieceDistance / 2) / kPieceDistance), 0), kNumPieces - 1);
                snapPosition.y = MIN(MAX(roundf((position.y - kPieceDistance / 2) / kPieceDistance), 0), kNumPieces - 1);
                index = snapPosition.y * kNumPieces + snapPosition.x;
                snapPosition.x = snapPosition.x * kPieceDistance + kPieceDistance / 2;
                snapPosition.y = snapPosition.y * kPieceDistance + kPieceDistance / 2;
            }
			
			
			snap = YES;
			for(i = 0; snap && (i < kNumPieces * kNumPieces); ++i) {
				if((_pieces[i] != piece) && ([_pieces[i] tag] == index))
                    snap = NO;
				
				if((index % kNumPieces >= 1) && ([_pieces[i] tag] == index - 1)) {
					if(i != [piece index] - 1)
                        snap = NO;
				}
				
				if((index % kNumPieces < kNumPieces - 1) && ([_pieces[i] tag] == index + 1)) {
					if(i != [piece index] + 1)
                        snap = NO;
				}
				
				if((index / kNumPieces >= 1) && ([_pieces[i] tag] == index - kNumPieces)) {
					if(i != [piece index] - kNumPieces)
                        snap = NO;
				}
				
				if((index / kNumPieces < kNumPieces - 1) && ([_pieces[i] tag] == index + kNumPieces)) {
					if(i != [piece index] + kNumPieces)
                        snap = NO;
				}
			}
			
			if(snap) {
				[piece setTag:index];
				
				[UIView beginAnimations:nil context:NULL];
				[piece setCenter:snapPosition];
				[UIView commitAnimations];
			}
			//Play sound
//			if(snap)
//               [MyMusicPlayer musicPlayer] playSnapSound];
//			else
//                [MyMusicPlayer musicPlayer] playDropSound];
		}
	}
	
	//Update piece shadow with animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	[piece updateShadow:NO forRotation:_puzzleRotation];
	[UIView commitAnimations];
	
	//If the piece was snapped, check if the puzzle is now completed
	if(snap) {
		for(i = 0; i < kNumPieces * kNumPieces; ++i)
            if([_pieces[i] tag] != [_pieces[i] index]) {
                snap = NO;
                break;
            }
		if(snap) {
            //Play sound
			//[_completedSound play];
			
			//Disable interaction with all pieces
			_completed = YES;
			for(i = 0; i < kNumPieces * kNumPieces; ++i)
                [_pieces[i] setUserInteractionEnabled:NO];
		}
	}
}

- (void) willAnimateFirstHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation
{
	CGFloat					angle = _OrientationAngles[fromOrientation] + (_OrientationAngles[toOrientation] - _OrientationAngles[fromOrientation]) / 2.0;
	CGAffineTransform		transform;
	NSUInteger				i;
	
	//Half-rotate background view
	transform = _MakeRoundedRotationTransform(angle);
	[_backgroundView setTransform:transform];
	
	//Half-rotate all pieces in the scrollview
	transform = _MakeRoundedRotationTransform(angle + _puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		if([_pieces[i] superview] == _scrollView)
            [_pieces[i] setTransform:transform];
	}
}

- (void) willAnimateSecondHalfOfRotationFromOrientation:(UIInterfaceOrientation)fromOrientation toOrientation:(UIInterfaceOrientation)toOrientation
{
	CGFloat					angle = _OrientationAngles[toOrientation];
	CGAffineTransform		transform;
	NSUInteger				i;
	
	//Rotate background view
	transform = _MakeRoundedRotationTransform(angle);
	[_backgroundView setTransform:transform];
	
	//Rotate all pieces in the scrollview
	transform = _MakeRoundedRotationTransform(angle + _puzzleRotation);
	for(i = 0; i < kNumPieces * kNumPieces; ++i) {
		if([_pieces[i] superview] == _scrollView)
            [_pieces[i] setTransform:transform];
	}
}
@end
