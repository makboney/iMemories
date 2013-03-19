//
//  Template.h
//  iMemories
//
//  Created by Boney's Macmini on 3/13/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Field, TemplateType;

@interface Template : NSManagedObject

@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * gameId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * updatedBy;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *field;
@property (nonatomic, retain) TemplateType *templateType;
@end

@interface Template (CoreDataGeneratedAccessors)

- (void)addFieldObject:(Field *)value;
- (void)removeFieldObject:(Field *)value;
- (void)addField:(NSSet *)values;
- (void)removeField:(NSSet *)values;

@end
