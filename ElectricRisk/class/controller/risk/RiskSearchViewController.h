//
//  RiskSearchViewController.h
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskProjectChooseViewController.h"
#import "RiskClassChooseViewController.h"

@protocol RishSearchDelegate <NSObject>

-(void)riskSearchWithArea:(NSString*)area andProjectid:(NSString*)projectid andSLevel:(NSString*)startLevel andEndLevel:(NSString*)endLevel;

@end

@interface RiskSearchViewController : UIViewController<RiskProjectChooseDelegate, RiskClassChooseDelegate>

@property (strong, nonatomic) NSArray* projectArray;
@property (strong, nonatomic) NSDictionary *currentProject;
@property (strong, nonatomic) NSString* startClass;
@property (strong, nonatomic) NSString* endClass;

@property (assign, nonatomic) id<RishSearchDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *areaNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *chooseProjectBtn;
@property (strong, nonatomic) IBOutlet UIButton *startClassBtn;
@property (strong, nonatomic) IBOutlet UIButton *endClassBtn;

- (IBAction)goBackBtnClick:(id)sender;
- (IBAction)chooseProjectBtnClick:(id)sender;
- (IBAction)startBtnClick:(id)sender;
- (IBAction)endClassBtnClick:(id)sender;

- (IBAction)resetBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;

- (void)initViewWithData:(NSArray*) projectArray;

@end
