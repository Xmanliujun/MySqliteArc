//
//  DatabaseConfiguration.m
//  PlusTimesPang
//
//  Created by kimpeng on 13-4-10.
//
//

#import "DatabaseConfiguration.h"
#import "Helper.h"

@implementation DatabaseConfiguration

@synthesize database;
@synthesize path;
@synthesize transactionCount;

static id _instance = nil;

+(id) instance {
	@synchronized(self) {
		if (! _instance) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

//- (void)dealloc
//{
//    [path release];
//    
//    [super dealloc];
//}

-(id)init {
	self = [super init];
	
	if (self) {
		NSString* storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"mySqlite.sqlite"];
        
		NSFileManager *fileManager = [NSFileManager defaultManager];
        
		if (![fileManager fileExistsAtPath:storePath]) {
			NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"mySqlite" ofType:@"sqlite"];
			if (defaultStorePath) {
				[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
			}
		}
		
		self.path = [[NSString alloc] initWithString:storePath];
		
		NSLog(@"path[%@]", path);
		
		isOpen = NO;
	}
	
	return self;
}

- (NSString *)applicationDocumentsDirectory
{
    return [Helper getDocumentPath];
}

-(sqlite3*) openDatabase
{
    if(isOpen == YES) {
		return database;
	}
    
	@try {
		if( sqlite3_open([ self.path UTF8String ], &database ) == SQLITE_OK ) {
			NSLog(@"OPEN DATABASE");
			isOpen = YES;
		} else {
			[self closeDatabase];
			NSLog( @"Failed to open databese with following message '%s'.", sqlite3_errmsg( database ));
			database = nil;
            
			NSString* errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg( database )];
			NSString* errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode( database )];
			@throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
		}
	}
	@catch(NSException* e) {
		NSLog(@"exception %@: %@", [e name], [e reason]);
		@throw e;
	}
	
	return database;
}

-(void) closeDatabase
{
    NSLog(@"CLOSE DATABASE");
	transactionCount = 0;
	if( database == nil ) {
		return;
	}
    
	if( sqlite3_close( database ) != SQLITE_OK ) {
		NSLog( @"Failed to close database with '%s'.", sqlite3_errmsg( database ));
		NSString* errMsg = [NSString stringWithFormat:@"%s",sqlite3_errmsg( database )];
		NSString* errCode = [NSString stringWithFormat:@"%d",sqlite3_errcode( database )];
		@throw [NSException exceptionWithName:errMsg reason:errCode userInfo:nil];
	}
	else {
		database = nil;
	}
	
	isOpen = NO;
}

-(void) beginTransaction {
	if (transactionCount == 0) {
		sqlite3_exec(database, "BEGIN TRANSACTION", 0, 0, 0);
	}
	transactionCount += 1;
}

-(void) commitTransaction {
	transactionCount -= 1;
	if (transactionCount == 0) {
		sqlite3_exec(database, "COMMIT TRANSACTION", 0, 0, 0);
	}
}

-(void) rollbackTransaction {
	transactionCount = 0;
	sqlite3_exec(database, "ROLLBACK TRANSACTION", 0, 0, 0);
}

@end

