//
//  Field.h
//  iMemories
//
//  Created by Boney's Macmini on 3/13/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Template;

@interface Field : NSManagedObject

@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * updatedBy;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *template;
@end

@interface Field (CoreDataGeneratedAccessors)

- (void)addTemplateObject:(Template *)value;
- (void)removeTemplateObject:(Template *)value;
- (void)addTemplate:(NSSet *)values;
- (void)removeTemplate:(NSSet *)values;

@end
