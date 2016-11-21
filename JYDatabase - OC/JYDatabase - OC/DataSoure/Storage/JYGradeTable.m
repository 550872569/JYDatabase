//
//  JYGradeTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYGradeTable.h"
#import "JYGradeInfo.h"
#import "JYClassTable.h"

@implementation JYGradeTable

- (void)configTableName{
    
    self.contentClass = [JYGradeInfo class];
    self.tableName = @"JYGradeTable";
}

- (NSString *)contentId{
    return @"gradeID";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"gradeName"];
}

// 设置关联的表
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
    
    JYClassTable *table = [[JYClassTable alloc] init];
    table.dbQueue = self.dbQueue;
    
    return @{
             @"allClass" : @{
                             tableContentObject : table,
                             tableViceKey       : @"gradeID"
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
