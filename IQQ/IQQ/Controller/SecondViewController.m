//
//  SecondViewController.m
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "SecondViewController.h"
#import "Question.h"
#import "DownloadDataTool.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface SecondViewController ()<sendDataDelegate>

//滚动视图
@property(nonatomic,retain)UIScrollView *secondScrollView;
//类型
@property(nonatomic,retain)UILabel *categoryLabel;
//返回按钮
@property(nonatomic,retain)UIButton *backButton;
//题目
@property(nonatomic,retain)UILabel *titleLabel;
//难度系数
@property(nonatomic,retain)UILabel *difficultyLabel;
//答案按钮数组
@property(nonatomic,retain)NSMutableArray *answersButtonArray;
//答案按钮
//@property(nonatomic,retain)UIButton *answersButton;
//上一题
@property(nonatomic,retain)UIButton *lastButton;
//解析按钮
@property(nonatomic,retain)UIButton *analysisButton;
//下一题
@property(nonatomic,retain)UIButton *nextButton;
//提交答案
@property(nonatomic,retain)UIButton *submitButton;
//解析数据
@property(nonatomic,retain)NSString *analysisStr;
//问题存放数组
@property(nonatomic,retain)NSMutableArray *questionArray;
//model
@property(nonatomic,retain)Question *question;
//获取最后一个答案button的tag值 以便设置secondScrollView的最大滚动范围
@property(nonatomic,assign)NSInteger lastAnswerButtonTag;
//动画
@property(nonatomic,retain)UIImageView *moveView;
//弹窗
@property(nonatomic,retain)UIAlertController *alert;
//答案转化成的 ABCD...
@property(nonatomic,retain)NSString *answersStr;

//接收每个类型总个数
@property(nonatomic,assign)NSInteger totalCountInt;
//下一页
@property(nonatomic,assign)NSInteger nextPageInt;
//答案的下标
@property(nonatomic,assign)NSInteger index;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //数据数组初始化
    self.questionArray = [NSMutableArray array];
    //背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
//    //毛玻璃效果
//    UIVisualEffectView *visualV = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    //    [imagev addSubview:visualV];
    
    //默认页数为0
    self.nextPageInt = 0;
    //数据下载
    [self downloadData];

    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:141/255.0 green:220/255.0 blue:232/255.0 alpha:1];
    //类型
    self.navigationItem.title = self.categoryStr;
    //导航栏右侧收藏按钮
    UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
    collect.frame = CGRectMake(0, 0, 32, 32);
    [collect setImage:[[UIImage imageNamed:@"iconfont-shoucangweishoucang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [collect setImage:[[UIImage imageNamed:@"iconfont-shoucangyishoucang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:collect];
    [collect addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];

    //控件初始化
    //滚动视图ScrollView
    self.secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-200)];
    //隐藏右侧滚动指示条
    _secondScrollView.showsVerticalScrollIndicator = NO;
    _secondScrollView.backgroundColor = [UIColor colorWithRed:141/255.0 green:220/255.0 blue:232/255.0 alpha:1];
    //_secondScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_secondScrollView];
    
    //设置背景图
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imagev.image = [UIImage imageNamed:@"背景"];
    [self.secondScrollView addSubview:imagev];
    self.view.backgroundColor = [UIColor colorWithRed:141/255.0 green:220/255.0 blue:232/255.0 alpha:1];

    
    //返回按钮
//    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _backButton.frame = CGRectMake(30, 30, 30, 30);
//    _backButton.layer.cornerRadius = 15;
//    _backButton.layer.masksToBounds = YES;
//    _backButton.backgroundColor = [UIColor redColor];
//    [_backButton setTitle:@"B" forState:UIControlStateNormal];
//    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_backButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
//    [_backButton addTarget:self action:@selector(backing) forControlEvents:UIControlEventTouchUpInside];
    
    //返回按钮
    UIImage *image = [UIImage imageNamed:@"iconfont-fanhui"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backing)];
    
    //提交答案按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(140, HEIGHT-190, 100, 50);
    _submitButton.backgroundColor = [UIColor orangeColor];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton setTitle:@"提交答案" forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(handleSubmitButtonAction) forControlEvents:UIControlEventTouchUpInside];

    //查看解析按钮
    self.analysisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _analysisButton.frame = CGRectMake(140, HEIGHT-130, 100, 30);
    _analysisButton.backgroundColor = [UIColor orangeColor];
    _analysisButton.layer.cornerRadius = 5;
    _analysisButton.layer.masksToBounds = YES;
    [_analysisButton setTitle:@"查看解析" forState:UIControlStateNormal];
    [self.view addSubview:_analysisButton];
    [_analysisButton addTarget:self action:@selector(handleAnalysisButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //下一题按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(250, HEIGHT-180, 100, 30);
    [_nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius = 5;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_nextButton];
    [self.nextButton addTarget:self action:@selector(nextQuestion) forControlEvents:UIControlEventTouchUpInside];
    
     //上一题按钮
        self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastButton.frame = CGRectMake(30, HEIGHT-180, 100, 30);
        [_lastButton setTitle:@"上一题" forState:UIControlStateNormal];
        _lastButton.layer.cornerRadius = 5;
        _lastButton.layer.masksToBounds = YES;
        _lastButton.backgroundColor = [UIColor grayColor];
        [self.lastButton addTarget:self action:@selector(lastQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_lastButton];

    //控件初始化
    [self setUpQuestionView];
    //加载时 动画
    [self moving];

}
//
-(void)downloadData
{
    if (self.categoryid == 4) {
        self.categoryid ++;
    }
    else if (self.categoryid == 5)
    {
        self.categoryid += 2;
    }
    DownloadDataTool *tool = [[DownloadDataTool alloc] init];
    [tool downloadWithUrl:[NSString stringWithFormat:@"http://tujiao.com:3838/v1/dailypuzzle/puzzle/list/?categoryid=%ld&limit=1&page=%ld",self.categoryid,self.nextPageInt]];
    tool.myDelegate = self;
    
}
-(void)sendData:(NSData *)data
{
        //数据处理 JSON解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.totalCountInt = [dict[@"totalCount"] integerValue];
    NSLog(@"%ld",self.totalCountInt);
    NSArray *recordsArray = [dict objectForKey:@"records"];
    
    
    NSDictionary *dict2 = recordsArray[0];
    NSArray *answersArray = [dict2 objectForKey:@"answers"];
    NSMutableArray *answersA = [NSMutableArray array];
    for (NSDictionary *answersDict in answersArray) {
        [answersA addObject:answersDict[@"answer"]];
        if ([dict2[@"image"] isEqual:@""]) {
            self.question = [Question questionWithTitle:dict2[@"title"] difficulty:[dict2[@"difficulty"] intValue] analysis:dict2[@"analysis"] answers:answersA];
        }
    }
    [self performSelectorOnMainThread:@selector(backToMainThread) withObject:data waitUntilDone:nil];
}
-(void)backToMainThread
{
    [self reloadMyView];
}
//控件初始化
-(void)setUpQuestionView
{
    //难度系数
    self.difficultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 110, 15)];
    [self.secondScrollView addSubview:_difficultyLabel];
    //题目
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, WIDTH-40, 20)];
//    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.secondScrollView addSubview:self.titleLabel];
}
//控件赋值（题目 答案 难度系数 解析）
-(void)reloadMyView
{
    //加载完成后若动画存在则移除动画
    if (_moveView) {
        [_moveView removeFromSuperview];
    }
    self.difficultyLabel.frame = CGRectMake(20, 20, 110, 15);
    self.titleLabel.text =  self.question.title;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.frame = CGRectMake(20, 50, WIDTH-40, 20);
    [self.titleLabel sizeToFit];
    self.difficultyLabel.text = [NSString stringWithFormat:@"难度系数：%ld",self.question.difficulty];
    self.analysisStr = self.question.analysis;
    //移除之前创建的答案按钮（不这样处理 屏幕会出现一堆答案按钮...）
    for (int i = 0; i < [self.answersButtonArray count]; i++) {
        UIButton *button = [self.secondScrollView viewWithTag:1000+i];
        [button removeFromSuperview];
    }
    //初始化答案按钮数组
    self.answersButtonArray = [NSMutableArray array];
    //重新创建答案按钮
    [self createAnswersButton];
    UIButton *button = [self.secondScrollView viewWithTag:self.lastAnswerButtonTag];
    //secondScrollView最大滚动范围
    _secondScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + 10);
}
//创建答案按钮
-(void)createAnswersButton
{
    //用for循环创建答案按钮
    for (int i = 0; i < [self.question.answers count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮Y间距
        button.tag = 1000+i;
//        CGFloat buttonSpacing = 20;
        CGFloat buttonSpacing = [self getButtonHeight:17 width:WIDTH-60 content:self.question.answers[i]];
        if (i == 0) {
            button.frame = CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame)+20, WIDTH-60, buttonSpacing);
        }else{
        button.frame = CGRectMake(30, CGRectGetMaxY([self.answersButtonArray[i-1] frame])+20, WIDTH-60, buttonSpacing);
        }
//        button.layer.cornerRadius = 5;
//        button.layer.masksToBounds = YES;
//        button.layer.borderColor = [UIColor blackColor].CGColor;
//        button.layer.borderWidth = 1;
        [button setTitle:self.question.answers[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleAnswersButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.numberOfLines = 0;
//        [button sizeToFit];
        button.backgroundColor = [UIColor clearColor];
        [self.secondScrollView addSubview:button];
        [self.answersButtonArray addObject:button];
        //获取最后一个答案button的tag值 以便设置secondScrollView的最大滚动范围
        self.lastAnswerButtonTag = 1000+i;
    }
}
-(CGFloat)getButtonHeight:(CGFloat)font width:(CGFloat)width content:(NSString *)content
{
    CGSize size = CGSizeMake(width, 10000);
     NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

//返回
-(void)backing
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
//点击提交答案按钮
-(void)handleSubmitButtonAction
{
    self.answersStr = nil;
    for (UIButton *button in self.answersButtonArray) {
        if (button.selected) {
            self.index = button.tag - 1000;
            //选择的答案
            NSString *answerStr = self.question.answers[self.index];
            NSRange answerRange = NSMakeRange(0, 1);
            self.answersStr = [answerStr substringWithRange:answerRange];
        }
    }
    //正确答案
    NSRange rightAnswerRange = NSMakeRange(2, 1);
    NSString *rightAnswerStr = [self.analysisStr substringWithRange:rightAnswerRange];
    
    NSString *title;
    NSString *message;
    //判断答案的对错
    if (self.answersStr.length == 0) {
        message = @"真相只有一个,请选择";
        title = nil;
    }else if ([self.answersStr isEqualToString:rightAnswerStr]) {
        //选择了就不能选择
        self.submitButton.userInteractionEnabled = NO;
        [self.submitButton setTitle:@"答对了" forState:UIControlStateNormal];
        message = @"Bingo!这智商没得说了";
        title = nil;
    }else
    {
        //选择了就不能选择
        self.submitButton.userInteractionEnabled = NO;
        [self.submitButton setTitle:@"答错了" forState:UIControlStateNormal];
        message = @"答错啦";
        title = @"恭喜你";
    }
    self.alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self alertController];
}

//点击答案响应
-(void)handleAnswersButtonAction:(UIButton *)sender
{
    for (UIButton *button in self.answersButtonArray) {
        button.selected = NO;
    }
    sender.selected = YES;
}
//弹窗
-(void)alertController
{
    [self presentViewController:_alert animated:YES completion:^{
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disappearAlert) userInfo:nil repeats:NO];
    
}
//收起弹窗
-(void)disappearAlert
{
    [self.alert dismissViewControllerAnimated:YES completion:^{
       
    }];
}
//查看上一题
-(void)lastQuestion
{
    if (self.nextPageInt>0) {
        self.nextPageInt--;
        [self downloadData];
    }else{
//        [self.lastButton removeFromSuperview];
    }
}
//查看解析
-(void)handleAnalysisButtonAction
{
    self.alert = [UIAlertController alertControllerWithTitle:@"百思不得其解" message:[NSString stringWithFormat:@"%@",self.question.analysis] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"已得其解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [_alert addAction:action];
    [self presentViewController:_alert animated:YES completion:^{
        
    }];
}
//查看下一题
-(void)nextQuestion
{
    self.submitButton.userInteractionEnabled = YES;
    [self.submitButton setTitle:@"提交答案" forState:UIControlStateNormal];
    if (self.nextPageInt >= 0 && self.nextPageInt <= self.totalCountInt) {
        self.nextPageInt++;
        [self downloadData];
    }
    else
    {
        self.nextPageInt = 0;
    }
    
}
//动画效果
-(void)moving
{
    self.moveView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //_logoImageView.image = [UIImage imageNamed:@"logo"];
    _moveView.layer.cornerRadius = 50;
    _moveView.layer.masksToBounds = YES;
    _moveView.center = self.secondScrollView.center;
    [self.view addSubview:_moveView];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSString *imageName = [NSString stringWithFormat:@"xwz_%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    _moveView.animationImages = imageArray;
    _moveView.animationDuration = 2;
    _moveView.animationRepeatCount = 0;
    [_moveView startAnimating];
}
#pragma mark 右侧收藏按钮
-(void)clickCollect:(UIButton *)button
{
    
    if (button.selected == YES) {
        self.alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏该题" preferredStyle:UIAlertControllerStyleAlert];
        [self alertController];
        button.selected = NO;
    }else{
        self.alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已收藏该题" preferredStyle:UIAlertControllerStyleAlert];
        [self alertController];
        button.selected = YES;
    }
    
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
