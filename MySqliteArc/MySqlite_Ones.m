//
//  MySqlite_Ones.m
//  MySqliteArc
//
//  Created by 刘军 on 13-7-17.
//  Copyright (c) 2013年 刘军. All rights reserved.
//

#import "MySqlite_Ones.h"


#define SELECT_ALL @"SELECT id,name,school,phone FROM mySqlite_sql ORDER BY id ASC;"

#define SELECT_SCH @"SELECT * FROM mySqlite_sql WHERE school = '%@';"

#define SELECT_LIKE @"SELECT id, name FROM mySqlite_sql WHERE phone = ? AND name LIKE '%%%@%%' ORDER BY id ASC;"

#define SELECT_PHONE @"SELECT * FROM mySqlite_sql WHERE phone = '%@';"

#define SELECT_TWO @"SELECT id ,name,school,phone FROM mySqlite_sql WHERE name = ? ORDER BY id ASC;"
//增加新条目
#define INSERT @"INSERT INTO mySqlite_sql ('name','school','phone') VALUES (?,?,?);"
//更新指定name条目的school和 phone 参数
#define UPDATE @"UPDATE mySqlite_sql SET school = ? , phone = ? WHERE name = ?;"
//删除指定的name条目
#define DELETE_ONE @"DELETE FROM mySqlite_sql WHERE name = ?;"
//全部删除
#define DELETE_ALL @"DELETE FROM mySqlite_sql;"

@implementation MySqlite_Ones

//全部删除
-(int)delete_all
{
    //初始化 数据库
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    
    sqlite3_stmt * statment = nil;
    BOOL result = NO;
    
    @try {
        [self beginTransaction];
       
        const char * sql = [DELETE_ALL UTF8String];
        int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
        
        if (status == SQLITE_OK) {
            
            if (sqlite3_step(statment) == SQLITE_DONE) {
                result = YES;
                
            }
            
        }
        if (result != YES) {
            NSString* errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg( database )];
			NSString* errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode( database )];
			@throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
        }
        
    }
    @catch (NSException *exception) {
        [self rollbackTransaction];
        
        @throw exception;
    }
    @finally {
        if (statment != nil) {
            sqlite3_finalize(statment);
        }
        if (result == YES) {
            [self commitTransaction];
        }
    }


    return result;

}


-(int)delete_one:(NSString *)name
{
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    BOOL result = NO;
    
    @try {
        [self beginTransaction];
        const char * sql = [DELETE_ONE UTF8String];
        int status =  sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
     
        if (status == SQLITE_OK) {
            int i = 1;
            [self setText:statment string:name index:i++];
            if (sqlite3_step(statment) == SQLITE_DONE) {
                result = YES;
                
            }
        }
        if (result != YES) {
            NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
            NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
            @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
            
        }
    }
    @catch (NSException *exception) {
        [self rollbackTransaction];
        @throw exception;
        
    }
    @finally {
        if (statment != nil) {
            sqlite3_finalize(statment);
            
        }
        if (result == YES) {
            [self commitTransaction];
            
        }
        
    }


    return result;

}


-(int)insert:(NSString *)name WithSch:(NSString *)school WithPhone:(NSString *)phone
{
    sqlite3* database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    BOOL result =  NO;
    
    @try {
        [self beginTransaction];
        //设置sql语句
        const char * sql = [INSERT UTF8String];
        int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
        if (status == SQLITE_OK) {
            
            int i = 1;
            
            [self setText:statment string:name index:i++];
            [self setText:statment string:school index:i++];
            [self setText:statment string:phone index:i++];
            
            if (sqlite3_step(statment) ==SQLITE_DONE) {
                
                result = YES;
                
                
            }
            
            
        }
        if (result != YES) {
            NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
            NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
            @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
            
        }
        
        
    }
    @catch (NSException *e) {
        [self rollbackTransaction];
        @throw  e;
    }
    @finally {
        if (statment != nil) {
            sqlite3_finalize(statment);
            
        }
        
        if (result == YES) {
            [self commitTransaction];
        }
        
        
    }

    return result;
    


}

-(int)updateSet:(NSString *)school WithSetPhone:(NSString *)phone WithByName:(NSString *)name
{
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    BOOL result = NO;
    
    @try {
        [self beginTransaction];
        const char * sql = [UPDATE UTF8String];
        int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
        
        if (status == SQLITE_OK) {
            int i = 1;
            
            [self setText:statment string:school index:i++];
            [self setText:statment string:phone index:i++];
            [self setText:statment string:name index:i++];
            
            if (sqlite3_step(statment) == SQLITE_DONE) {
                result = YES;
                
            }
            
            
        }
        
        if (result != YES) {
            NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
            NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
            @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
            
        }
        
    }
    @catch (NSException *exception) {
        [self rollbackTransaction];
        @throw exception;
        
    }
    @finally {
        
        if (statment != nil) {
            sqlite3_finalize(statment);
            
        }
        if (result == YES) {
            [self commitTransaction];
        }
        
        
        
        
    }


    return result;


}


-(NSMutableArray * )getSelectAll
{
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statemtnt = nil;
    NSMutableArray * result = nil;
    
    const char * sql = [SELECT_ALL UTF8String];
    int status = sqlite3_prepare_v2(database, sql, -1, &statemtnt, NULL);
    
    if (status == SQLITE_OK) {
        
        result = [[NSMutableArray alloc] initWithCapacity:0];
        
        while (sqlite3_step(statemtnt) == SQLITE_ROW ) {
            
            [result addObject:[self getEntity:statemtnt]];
            
        }
        
        
    }else {
        NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
        NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
        @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];


    }
    sqlite3_finalize(statemtnt);

    return result;
}

-(NSMutableArray *)getSelectPhone:(NSString *)phone
{
    sqlite3* database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    NSMutableArray * result = nil;
    
    NSString * strSql = [NSString stringWithFormat:SELECT_PHONE,phone];
    
    const char * sql = [strSql UTF8String];
    int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
    
    if (status == SQLITE_OK) {
        
        int i  = 1;
        
        [self setText:statment string:phone index:i++];
        
        result = [[NSMutableArray alloc] initWithCapacity:0];;
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            [result addObject:[self getName:statment]];
            
            
        }
        
    }else{
    
        NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
        NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
        @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
    
    
    }

    sqlite3_finalize(statment);
    return  result;

    
}

-(NSMutableArray *)getSelectTwo:(NSString *)name WithTwo:(NSString *)sch
{
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    NSMutableArray * result = nil;
  //  NSString * strSql = [NSString stringWithFormat:SELECT_TWO,name,sch];
    const char * sql = [SELECT_TWO UTF8String];

    int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
    NSLog(@"status %d",status);
    
    if (status == SQLITE_OK) {
        int i = 1;
   
        [self setText:statment string:name index:i++];
       // [self setText:statment string:sch index:i++];
        NSLog(@"i  %d",i);
       
        result = [[NSMutableArray alloc] initWithCapacity:0];
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            [result addObject:[self getName:statment]];
            
        }
        
        
    }else{
    
        NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
        NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
        @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
    
    
    }

    sqlite3_finalize(statment);
    return result;

}

-(NSMutableArray *)getSelectUniversity:(NSString *)name
{
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    NSMutableArray * result = nil;
    NSString * strSql = [NSString stringWithFormat:SELECT_SCH,name ];
    NSLog(@"strSql is  %@",strSql);
    const char * sql = [strSql UTF8String];
    
    int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);

    if (status == SQLITE_OK) {
        
        int i = 1;
        
        [self setText:statment string:name index:i++];
        
        result = [[NSMutableArray alloc] initWithCapacity:0];
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            [result addObject:[self getName:statment]];
            

            
        }
        
        
        
    }else{
    
        NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
        NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
        @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];


    
    }

    sqlite3_finalize(statment);

    return result;



}

-(NSMutableArray *)getUniversityName:(NSString *)name andName:(NSString *)sch
{
    
    sqlite3 * database = [[DatabaseConfiguration instance] database];
    sqlite3_stmt * statment = nil;
    NSMutableArray * result = nil;
    NSString * strSql = [NSString stringWithFormat:SELECT_LIKE,name];
    const char * sql = [strSql UTF8String];
    int status = sqlite3_prepare_v2(database, sql, -1, &statment, NULL);
    
    if (status == SQLITE_OK) {
        
        int i = 1;
        
        [self setText:statment string:name index:i++];
        [self setText:statment string:sch index:i++];
        
        result = [[NSMutableArray alloc] initWithCapacity:0];
        while (sqlite3_step(statment) == SQLITE_ROW) {
            
            [result addObject:[self getName:statment]];
            
            
        }
        
        
    }else{
    
        NSString * errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg(database)];
        NSString * errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode(database)];
        @throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];

    }
    
    sqlite3_finalize(statment);
    
    return result;
    

}

- (DataString *)getName:(sqlite3_stmt*)statement
{
    int i = 0;
    
    DataString *db = [[DataString alloc] init];
    
    db.record_id = [self getInteger:statement columnIndex:i++];
    db.name      = [self getString:statement columnIndex:i++ nullValue:nil];
    db.school      = [self getString:statement columnIndex:i++ nullValue:nil];
    db.phone  = [self getString:statement columnIndex:i++ nullValue:nil];

    return db;
}


-(DataString*)getEntity:(sqlite3_stmt*)statement
{
    int i = 0;
    
    DataString *db = [[DataString alloc] init];
    db.record_id = [self getInteger:statement columnIndex:i++];
    db.name      = [self getString:statement columnIndex:i++ nullValue:nil];
    db.school      = [self getString:statement columnIndex:i++ nullValue:nil];
    db.phone  = [self getString:statement columnIndex:i++ nullValue:nil];
    return db;
    
}
-(sqlite3*)openDatabase
{
	return [[DatabaseConfiguration instance] openDatabase];
}

-(void)closeDatabase
{
	[[DatabaseConfiguration instance] closeDatabase];
}

-(void) beginTransaction
{
	[[DatabaseConfiguration instance] beginTransaction];
}

-(void) commitTransaction
{
	[[DatabaseConfiguration instance] commitTransaction];
}

-(void) rollbackTransaction
{
	[[DatabaseConfiguration instance] rollbackTransaction];
}

@end
