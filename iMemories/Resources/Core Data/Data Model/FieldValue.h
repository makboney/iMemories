//
//  FieldValue.h
//  iMemories
//
//  Created by Boney's Macmini on 3/13/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Template;

@interface FieldValue : NSManagedObject

@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * updatedBy;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSData * value;
@property (nonatomic, retain) Template *template;

@end
