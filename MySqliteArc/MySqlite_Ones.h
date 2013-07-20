//
//  MySqlite_Ones.h
//  MySqliteArc
//
//  Created by 刘军 on 13-7-17.
//  Copyright (c) 2013年 刘军. All rights reserved.
//



#import "Model.h"
#import "DataString.h"

@interface MySqlite_Ones : Model

- (NSMutableArray *)getSelectAll;

- (NSMutableArray *)getSelectUniversity:(NSString *)name;

- (NSMutableArray *)getSelectPhone:(NSString *)phone;

- (NSMutableArray *)getSelectTwo:(NSString * )name WithTwo:(NSString *)sch;

- (NSMutableArray *)getUniversityName:(NSString *)name andName:(NSString *)sch;

- (int)insert:(NSString *)name WithSch:(NSString *)school WithPhone:(NSString *)phone;

- (int)updateSet:(NSString *)school WithSetPhone:(NSString *)phone WithByName:(NSString *)name;

- (int)delete_one:(NSString *)name;

- (int)delete_all;


@end
