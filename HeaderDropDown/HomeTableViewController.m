//
//  HomeTableViewController.m
//  HeaderDropDown
//
//  Created by 惠上科技 on 2018/12/18.
//  Copyright © 2018 惠上科技. All rights reserved.
//

#import "HomeTableViewController.h"
#import "UIImage+Blur.h"
#define IMAGE(name) [UIImage imageNamed:name]
@interface HomeTableViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundLayout;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self methodsOne];
    [self methodsTwo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


-(void)methodsOne{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    [self setBlurryImage:IMAGE(@"mine_bg.jpg") blurredValue:0.9];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.imageView.clipsToBounds = YES;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.tableView addSubview:self.imageView];
}

-(void)methodsTwo{
    CGFloat statusHeight = -[[UIApplication sharedApplication] statusBarFrame].size.height;
    [self setBlurryImage:IMAGE(@"mine_bg.jpg") blurredValue:0.9];
    self.backgroundLayout.constant = statusHeight;
}

/**
 *  高斯图片
 *
 *  @param originalImage 需要高斯的图片
 */
- (void)setBlurryImage:(UIImage *)originalImage blurredValue:(CGFloat)value {
    UIImage *blurredImage = [originalImage blurredImage:value];
    self.imageView.image = blurredImage;
    self.backgroundImage.image = blurredImage;
}

#pragma mark - UITableViewDataSource & delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView:scrollView.contentOffset];
}


/**
 *  通过scrollview的滑动改变顶部view的大小和高斯效果
 *
 *  @param offset scrollview下滑的距离
 */
-(void)updateHeaderView:(CGPoint) offset {
    if (offset.y <= self.backgroundLayout.constant) {
        CGRect frame = self.tableView.tableHeaderView.frame;
        CGRect rect = CGRectMake(0, 0, frame.size.width, 200);
        CGFloat delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageView.frame = rect;
        self.backgroundImage.frame = rect;
        CGFloat alpha = fabs((offset.y - self.backgroundLayout.constant) / (2 * CGRectGetHeight(rect) / 3));
        [self setBlurryImage:IMAGE(@"mine_bg.jpg") blurredValue:0.9-alpha];
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
