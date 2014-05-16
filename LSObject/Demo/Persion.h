//
//  Persion.h
//  Dictionary2Object
//
//  Created by History on 14-5-13.
//  Copyright (c) 2014年 History. All rights reserved.
//

#import "LSObject.h"
#import "Student.h"

@interface Persion : LSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, retain) NSArray *studentAry;
@property (nonatomic, retain) Student *student;
@end
