//
//  Template.h
//  Attendance Manager
//
//  Created by Oleksandr Mokretsov on 3/30/15.
//  Copyright (c) 2015 Oleksandr Mokretsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weekdays;

@interface Template : NSManagedObject

@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) Weekdays *weekdays;

@end
