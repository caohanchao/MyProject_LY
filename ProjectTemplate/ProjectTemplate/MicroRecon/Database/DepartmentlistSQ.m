//
//  DepartmentlistSQ.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DepartmentlistSQ.h"


@interface DepartmentlistSQ()


@end

@implementation DepartmentlistSQ


//根据FMDatabase获取UserlistDAO对象
+ (instancetype)departmentlistDAO {
    DepartmentlistSQ *dao = [[DepartmentlistSQ alloc] init];
   
    return dao;
}

// 插入一条信息到列表
- (BOOL)insertDepartmentlist:(UnitListModel *)model {
    
    __block BOOL ret;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
    ret = [db executeUpdate:@"insert into tb_departmentlist(DE_number,DE_name,DE_sjnumber,DE_level,DE_count,DE_describe1,DE_describe2,DE_type) values(?,?,?,?,?,?,?,?)",model.DE_number,model.DE_name,model.DE_sjnumber,model.DE_level,model.DE_count,model.DE_describe1,model.DE_describe2,model.DE_type];
    
    }];
        
    return ret;

}
//事务插入消息（处理大量数据）
- (void)transactionInsertDepartmentlist:(NSArray *)array {
    
    
    NSInteger count = array.count;
    __block BOOL ret;
   
        for (int i = 0; i < count; i++) {
        UnitListModel *model = array[i];
        [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
            ret = [db executeUpdate:@"insert into tb_departmentlist(DE_number,DE_name,DE_sjnumber,DE_level,DE_count,DE_describe1,DE_describe2,DE_type) values(?,?,?,?,?,?,?,?)",model.DE_number,model.DE_name,model.DE_sjnumber,model.DE_level,model.DE_count,model.DE_describe1,model.DE_describe2,model.DE_type];
        
    }];
  }
       
}
// 根据id查询在消息列表对应的消息
- (UnitListModel *)selectDepartmentlistById:(NSString *)Id {
    
    __block UnitListModel *tempModel;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:@"select * from tb_departmentlist where DE_number = ?", Id];
        if (set.next) {
            UnitListModel *model = [[UnitListModel alloc] init];
            model.DE_number = [set stringForColumn:@"DE_number"];
            model.DE_name = [set stringForColumn:@"DE_name"];
            model.DE_sjnumber = [set stringForColumn:@"DE_sjnumber"];
            model.DE_level = [set stringForColumn:@"DE_level"];
            model.DE_count = [set stringForColumn:@"DE_count"];
            model.DE_describe1 = [set stringForColumn:@"DE_describe1"];
            model.DE_describe2 = [set stringForColumn:@"DE_describe2"];
            model.DE_type = [set stringForColumn:@"DE_type"];
            tempModel = model;
        }
        [set close];

        
    }];
    
   
    return tempModel;
}



// 查询所有的消息
- (NSMutableArray *)selectDepartmentlists {

    __block NSMutableArray *array = [NSMutableArray array];
    
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from tb_departmentlist"];
        while (set.next) {
            
            UnitListModel *model = [[UnitListModel alloc] init];
            model.DE_number = [set stringForColumn:@"DE_number"];
            model.DE_name = [set stringForColumn:@"DE_name"];
            model.DE_sjnumber = [set stringForColumn:@"DE_sjnumber"];
            model.DE_level = [set stringForColumn:@"DE_level"];
            model.DE_count = [set stringForColumn:@"DE_count"];
            model.DE_describe1 = [set stringForColumn:@"DE_describe1"];
            model.DE_describe2 = [set stringForColumn:@"DE_describe2"];
            model.DE_type = [set stringForColumn:@"DE_type"];
            [array addObject:model];
        }
        [set close];
        
    }];
    
   return array;
}

//查询列表数
- (NSInteger)getCountsFromDB {
    
    
    __block NSInteger count = 0;
    [[ZEBDatabaseHelper sharedInstance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select count(*) from tb_departmentlist";
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            //查找 指定类型的记录条数
            count = [[rs stringForColumnIndex:0] integerValue];
        }
        [rs close];
    }];
    
    return count;
    
}
@end
