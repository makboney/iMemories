//
//  TemplateType.h
//  iMemories
//
//  Created by Boney's Macmini on 3/13/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TemplateType : NSManagedObject

@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * updatedBy;
@property (nonatomic, retain) NSDate * updatedDate;

@end
