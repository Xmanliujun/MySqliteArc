//
//  RootViewController.m
//  MySqliteArc
//
//  Created by 刘军 on 13-7-17.
//  Copyright (c) 2013年 刘军. All rights reserved.
//

#import "RootViewController.h"
#import "MySqlite_Ones.h"
@interface RootViewController ()

@end

@implementation RootViewController
@synthesize database;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    MySqlite_Ones * s = [[MySqlite_Ones alloc] init];
   
    [s openDatabase];

    // NSMutableArray * a =  [s getUniversityName:[NSString stringWithFormat:@"liu"] andName:[NSString stringWithFormat:@"H"]];
  
    // NSMutableArray * a = [s getSelectUniversity:[NSString stringWithFormat:@"H"]];
   
    [s insert:@"sun" WithSch:@"U" WithPhone:@"111"];
 
   //  NSMutableArray *  a = [s getSelectTwo:@"liu" WithTwo:@"H"];
   
   // [s updateSet:@"K" WithSetPhone:@"333" WithByName:@"sun"];
    
   // [s delete_one:@"sun"];
    
    NSMutableArray * a = [s getSelectPhone:[NSString stringWithFormat:@"111"]];
  
    // NSMutableArray * a = [s getSelectAll];
  
    NSLog(@"a is  %@",a);
    NSLog(@"a is  %d",a.count);

    if (a.count != 0) {
        DataString * d = [a objectAtIndex:0];
        NSLog(@"0 is %d",d.record_id);
        NSLog(@"1 is %@",d.name);
        NSLog(@"2 is %@",d.school);
        NSLog(@"3 is %@",d.phone);
    }
   
    [s closeDatabase];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
