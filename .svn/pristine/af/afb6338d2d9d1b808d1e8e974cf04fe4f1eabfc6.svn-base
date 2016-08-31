//
//  MSASearchViewController.h
//  MySchapp
//
//  Created by CK-Dev on 23/02/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSANetworkHandler.h"
#import "AFNetworking.h"

@protocol SearchResultCallbackDelegate <NSObject>

-(void)expandSearchResultView:(BOOL)expand;

@end

@protocol MenuButtonDelegate <NSObject>

- (void)showMenu:(id)sender;

@end

@interface MSASearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSLayoutConstraint *menuBtnConstraint;
@property (nonatomic, strong) UISearchBar *globalSearchBar;
@property(nonatomic,strong) NSMutableArray *searchResultProducts;
@property (nonatomic, strong) UIButton *drawerBtn;
@property(nonatomic,weak) id<SearchResultCallbackDelegate> delegate;
@property(nonatomic,weak) id<MenuButtonDelegate> menuDelegate;

@end
