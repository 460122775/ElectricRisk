//
//  RiskProjectChooseViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/4/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RiskProjectChooseDelegate <NSObject>

-(void)projectChooseControl:(NSDictionary*)project;

@end

@interface RiskProjectChooseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *projectArray;
@property (strong, nonatomic) id<RiskProjectChooseDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancelBtnClick:(id)sender;

- (void)initViewWithData:(NSArray*) tableArray;

@end
