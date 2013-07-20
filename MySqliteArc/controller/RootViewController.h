//
//  RootViewController.h
//  MySqliteArc
//
//  Created by 刘军 on 13-7-17.
//  Copyright (c) 2013年 刘军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface RootViewController : UIViewController
{

    sqlite3 * database;
    BOOL isOpen;
    
}

@property (nonatomic, readonly) sqlite3  *database;

@end
