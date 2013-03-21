//
//  PhotoManager.h
//  iMemories
//
//  Created by Boney's Macmini on 3/20/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@protocol PhotoManagerDelegate
@optional
- (void)photoInfosAvailable:(NSArray *)imageInfos done:(BOOL)done;
@optional
- (void)photosSaved:(BOOL)done;
@end

@interface PhotoManager : NSObject
{
    dispatch_queue_t backgroundQueue;
    NSString *_documentsPath;
    NSString *_albumName;
}
@property (retain) NSArray * images;
@property (assign) id<PhotoManagerDelegate> delegate;

- (id)initWithAlbumName:(NSString *)albumName andImages:(NSArray *)images delegate:(id<PhotoManagerDelegate>)theDelegate;
//- (id)initWithAlbumName:(NSString *)albumName delegate:(id<PhotoManagerDelegate>)theDelegate;
- (void)startSaving;
- (void)startRetrieving;
@end
