//
//  JYClassTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYClassTable.h"
#import "JYClassInfo.h"
#import "JYPersonTable.h"

@implementation JYClassTable

- (void)configTableName{
    
    self.contentClass = [JYClassInfo class];
    self.tableName = @"JYClassTable";
}

- (NSString *)contentId{
    return @"classID";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"className",@"gradeID"];
}

// 设置关联的表
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
    
    JYPersonTable *table = [[JYPersonTable alloc] init];
    table.dbQueue = self.dbQueue;
    
    return @{
             @"teacher" : @{
                             tableContentObject : table,
                             tableViceKey       : @"teacherClassID"
                           },
             @"students" : @{
                             tableContentObject : table,
                             tableViceKey       : @"studentClassID"
                           }
             };
}

// 为 gradeID 加上索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB{
    [self addDB:aDB uniques:@[@"gradeID"]];
}

// 不使用缓存，开发中建议打开
- (BOOL)enableCache{
    return NO;
}


@end
