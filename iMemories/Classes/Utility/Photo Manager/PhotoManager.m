//
//  PhotoManager.m
//  iMemories
//
//  Created by Boney's Macmini on 3/20/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager
@synthesize images = _images;
@synthesize delegate = _delegate;
- (id)initWithAlbumName:(NSString *)albumName andImages:(NSArray *)images delegate:(id<PhotoManagerDelegate>)theDelegate {
    
    if ((self = [super init])) {
        _albumName = albumName;
        self.images = images;
        _delegate = theDelegate;
        backgroundQueue = dispatch_queue_create("com.surroundapps.imeories.bgqueue", NULL);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsPath = [paths objectAtIndex:0];
    }
    return self;
}

- (void)startRetrievingProcess{
    NSFileManager *fileMangr = [NSFileManager defaultManager];
    
    NSArray *dirContents = [fileMangr contentsOfDirectoryAtPath:[_documentsPath stringByAppendingPathComponent:_albumName] error:nil];
    NSMutableArray *arrayOfImages = [[NSMutableArray alloc] initWithCapacity:[dirContents count]];
    NSString *dataPath = [_documentsPath stringByAppendingPathComponent:_albumName];
    int i = 0;
    for(NSString *strFilePath in dirContents)
    {
        if ([[strFilePath pathExtension] isEqualToString:@"jpg"] || [[strFilePath pathExtension] isEqualToString:@"png"] || [[strFilePath pathExtension] isEqualToString:@"PNG"])
        {
            NSString *imagePath = [[dataPath stringByAppendingFormat:@"/"] stringByAppendingPathComponent:strFilePath];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            if(data)
            {
                UIImage *image = [UIImage imageWithData:data];
                [arrayOfImages addObject:image];
                i++;
            }
        }
        
    }
    NSLog(@"Count %d",[dirContents count]);
    dispatch_async(backgroundQueue, ^void {    
        [_delegate photoInfosAvailable:[arrayOfImages autorelease] done:(i == [dirContents count])];
    });
}
- (void)startSavingProcess{

    
    NSString *dataPath = [_documentsPath stringByAppendingPathComponent:_albumName];
    
    NSFileManager *fileMangr = [NSFileManager defaultManager];
    NSArray *dirContents = [fileMangr contentsOfDirectoryAtPath:[_documentsPath stringByAppendingPathComponent:_albumName] error:nil];
    NSLog(@"images %d",[_images count]);
    if ([dirContents count] > 0 ) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/",dataPath] error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    int  i = 0;
    for (UIImage *image in _images) {
        NSString *imageName = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i++]];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:imageName atomically:YES];
    }
    dispatch_async(backgroundQueue, ^void {
        [_delegate photosSaved:YES];
    });
    
}
- (void)startRetrieving{
    dispatch_async(backgroundQueue, ^(void){
        [self startRetrievingProcess];
    });
}
- (void)startSaving{
    
    dispatch_async(backgroundQueue, ^(void){
        [self startSavingProcess];
    });    
}
@end
