//
//  HomeViewController.m
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "HomeViewController.h"
#import "SecondViewController.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UIImageView *logoImageView;
//@property(nonatomic,retain)UILabel *firstLabel;
//@property(nonatomic,retain)UILabel *firstBLabel;
//@property(nonatomic,retain)UILabel *secondLabel;
//@property(nonatomic,retain)UILabel *secondBLabel;
//@property(nonatomic,retain)UILabel *thirdLabel;
//@property(nonatomic,retain)UILabel *thirdBLabel;
//@property(nonatomic,retain)UILabel *fourthLabel;
//@property(nonatomic,retain)UILabel *fourthBLabel;
//@property(nonatomic,retain)UILabel *fifthLabel;
//@property(nonatomic,retain)UILabel *fifthBLabel;
//@property(nonatomic,retain)UILabel *sixLabel;
//@property(nonatomic,retain)UILabel *sixBLabel;

@property(nonatomic,retain)UITableView *homeTableView;
@property(nonatomic,retain)NSMutableArray *titleArray;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"随机",@"侦探推理",@"逻辑推理",@"数字推理",@"趣味数学",@"脑筋急转弯", nil];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //_logoImageView.image = [UIImage imageNamed:@"logo"];
    _logoImageView.layer.cornerRadius = 50;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _logoImageView.layer.borderWidth = 1;
    _logoImageView.center = CGPointMake(self.view.center.x, _logoImageView.center.y);
    [self.view addSubview:_logoImageView];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSString *imageName = [NSString stringWithFormat:@"xwz_%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    _logoImageView.animationImages = imageArray;
    _logoImageView.animationDuration = 2;
    _logoImageView.animationRepeatCount = 0;
    [_logoImageView startAnimating];
    
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 240, WIDTH-240, HEIGHT-400) style:UITableViewStylePlain];
    _homeTableView.center = CGPointMake(self.view.center.x, _homeTableView.center.y);
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    //禁止滚动
    _homeTableView.scrollEnabled = NO;
    [self.view addSubview:_homeTableView];
    [self.homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    //文字颜色
    cell.textLabel.textColor = [UIColor grayColor];
    //文字居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //选中文字颜色
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    //自定义选中背景为透明
    UIView *cellSelectBGView = [[UIView alloc] initWithFrame:cell.bounds];
    cellSelectBGView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellSelectBGView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.categoryid = indexPath.row;
    secondVC.categoryStr = self.titleArray[indexPath.row];
    UINavigationController *secondNC = [[UINavigationController alloc] initWithRootViewController:secondVC];
    secondNC.navigationBar.barTintColor = [UIColor whiteColor];
    secondNC.navigationBar.translucent = NO;
    [self presentViewController:secondNC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
