//
//  ViewController.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "ViewController.h"
#import "JYDBService.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSDate *date = [NSDate new];
  NSArray *aa = [[JYDBService shared] getPersonInfoByConditions:^(JYQueryConditions *make) {
        make.field(@"personnumber").greaterThanOrEqualTo(@"123456000100");
        make.field(@"bool1").equalTo(@"1");
        make.field(@"personnumber").lessThanOrEqualTo(@"123456000200");
    }];
    NSLog(@"%f -- %tu",[date timeIntervalSinceNow],aa.count);
}

- (void)add {
    
    static NSInteger bj = 0;
    NSMutableArray *personArrayM = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 2000; i++) {
        
        JYPersonInfo *info = [[JYPersonInfo alloc] init];
        info.personnumber = [NSString stringWithFormat:@"123456%tu%05tu",bj,i];
        info.float1 = 10.10111;
        info.name = @"测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小";
        info.desc = @"测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小测试存储 1万条数据的大小";
        info.int1 = i;
        info.bool1 = i % 2 == 0;
        info.integer1 = -100;
        
        NSMutableArray *testArrayM = [[NSMutableArray alloc] init];
        for (int j = 0; j < 10; j++) {
            JYTest1Content *test = [[JYTest1Content alloc] init];
            test.testID = [NSString stringWithFormat:@"%tu-%tu-%tu",bj,i,j];
            test.personID = info.personnumber;
            test.acgfloatDB = i * 1.5;
            test.numberDB = [NSNumber numberWithInteger:i];
            [testArrayM addObject:test];
        }
        info.test1Contents = [testArrayM copy];
        
        JYTest1Content *test1 = [[JYTest1Content alloc] init];
        test1.testID = [NSString stringWithFormat:@"%tu-%tu-%tu",bj,i,i];
        test1.testPersonID = info.personnumber;
        test1.acgfloatDB = i * 1.5;
        test1.numberDB = [NSNumber numberWithInteger:i];
        info.test1 = test1;
        
        [personArrayM addObject:info];
    }
    NSDate *date = [NSDate new];
    [[JYDBService shared] insertPersonInfos:personArrayM];
    NSLog(@"%f",[date timeIntervalSinceNow]);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self add];
    // Do any additional setup after loading the view, typically from a nib.
        UIButton *button1 = [self addButtonTitle:@"查询单条" action:@selector(getConttent:)];
    button1.frame = CGRectMake(0, 64, 80, 50);
    
    UIButton *button2 = [self addButtonTitle:@"查询所有" action:@selector(getAllConttent:)];
    button2.frame = CGRectMake(100, 64, 80, 50);
    
    UIButton *button3 = [self addButtonTitle:@"查询多条" action:@selector(getConttents:)];
    button3.frame = CGRectMake(200, 64, 80, 50);
    
    UIButton *button4 = [self addButtonTitle:@"删除单条" action:@selector(deleteConttent:)];
    button4.frame = CGRectMake(0, 164, 80, 50);
    
    UIButton *button5 = [self addButtonTitle:@"删除所有" action:@selector(deleteAllConttent:)];
    button5.frame = CGRectMake(100, 164, 80, 50);
    
    UIButton *button6 = [self addButtonTitle:@"删除多条" action:@selector(deleteConttents:)];
    button6.frame = CGRectMake(200, 164, 80, 50);
    
    UIButton *button7 = [self addButtonTitle:@"条件查询" action:@selector(compareConttents:)];
    button7.frame = CGRectMake(0, 264, 80, 50);
    
    UIButton *button8 = [self addButtonTitle:@"条件删除" action:@selector(deleteCompareConttents:)];
    button8.frame = CGRectMake(200, 264, 80, 50);
    
    UIButton *button9 = [self addButtonTitle:@"清除" action:@selector(clearnCompareConttents:)];
    button9.frame = CGRectMake(100, 264, 80, 50);
    
    self.imageView.frame = CGRectMake(0, 350, 200, 100);
}

- (void)clearnCompareConttents:(UIButton*)but{
    [[JYDBService shared] cleanPersonInfoBefore:[NSDate date]];
}

- (void)deleteCompareConttents:(UIButton*)but{
    [[JYDBService shared] deletePersonInfoByConditions:^(JYQueryConditions *make) {
        make.field(@"personnumber").greaterThanOrEqualTo(@"12345620");
        make.field(@"bool1").equalTo(@"1");
        make.field(@"personnumber").lessTo(@"12345630");
    }];
}

- (void)compareConttents:(UIButton*)but{
   NSArray*infos = [[JYDBService shared] getPersonInfoByConditions:^(JYQueryConditions *make) {
        make.field(@"personnumber").greaterThanOrEqualTo(@"12345620");
        make.field(@"bool1").equalTo(@"1");
        make.field(@"personnumber").lessTo(@"12345630");
//       make.sqlStr(@"personnumber < 12345630");
//        make.asc(@"bool1").desc(@"int1");
    }];
    
    NSLog(@"%@",infos);
}

- (void)deleteConttent:(UIButton*)but{
    [[JYDBService shared] deletePersonInfo:@"1234560"];
}

- (void)deleteConttents:(UIButton*)but{
    [[JYDBService shared] deletePersonInfos:@[@"1234560",@"12345610",@"12345611",@"1234562",@"abcde"]];
}

- (void)deleteAllConttent:(UIButton*)but{
    NSDate *date = [NSDate new];
    [[JYDBService shared] deleteAllPersonInfo];
    NSLog(@"%f",[date timeIntervalSinceNow]);
}

- (void)getConttent:(UIButton*)but{
   JYPersonInfo* info = [[JYDBService shared] getPersonInfo:@"aaa"];
    NSLog(@"%f",info.lastInsertTime);
    self.imageView.image = info.image;
//    NSArray* infos = [[JYDBService shared] getAllTest1Content];
//   NSLog(@"%@",infos);
}

- (void)getConttents:(UIButton*)but{
    NSArray<JYPersonInfo*>* infos = [[JYDBService shared] getPersonInfos:@[@"1234560",@"12345610",@"12345611",@"1234562",@"abcde"]];
    self.imageView.image = infos.firstObject.image;
    NSLog(@"%@",infos);
}

- (void)getAllConttent:(UIButton*)but{
    NSArray<JYPersonInfo *>* infos = [[JYDBService shared] getAllPersonInfo];
    NSLog(@"%@ -- %@ ++ %@",infos,infos.firstObject.test1Contents,infos.firstObject.test1);
}

- (UIButton *)addButtonTitle:(NSString*)aTitle action:(SEL)aSel{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button addTarget:self action:aSel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
