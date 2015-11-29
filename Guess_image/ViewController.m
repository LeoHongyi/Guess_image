//
//  ViewController.m
//  Guess_image
//
//  Created by apple on 6/1/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"

@interface ViewController ()<UIAlertViewDelegate>
- (IBAction)tip;
- (IBAction)bigImg;
- (IBAction)nextQuestion;
- (IBAction)help;
- (IBAction)iconClick;
@property (weak, nonatomic) IBOutlet UIView *answerView;

@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;

@property(nonatomic,strong)NSArray *questions;
@property(nonatomic,assign)int index;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) UIButton *cover;
@property (nonatomic,assign) CGFloat iconX;
@property (nonatomic,assign) CGFloat iconY;
@property (nonatomic,assign) CGFloat iconW;
@property (nonatomic,assign) CGFloat iconH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = -1;
    [self nextQuestion];
    
   
}


-(void)addScore:(int)deltaScore{
    int score = [self.scoreBtn titleForState:UIControlStateNormal].intValue;
    score += deltaScore;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d",score] forState:UIControlStateNormal];
    
}

-(NSArray *)questions
{
    if(_questions == nil){
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
        NSMutableArray *questionArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Question *question = [Question questionWithDict:dict];
            [questionArray addObject:question];
            
            
        }
        
        _questions = questionArray;
        
    }
    return _questions;
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (IBAction)tip {
    
    // 1.点击所有的答案按钮
    for (UIButton *answerBtn in self.answerView.subviews) {
        [self answerClick:answerBtn];
    }
    
    // 2.取出答案
    Question *question = self.questions[self.index];
    // 答案的第一个文字
    NSString *firstAnswer = [question.answer substringToIndex:1];
    for (UIButton *optionBtn in self.optionView.subviews) {
        if ([optionBtn.currentTitle isEqualToString:firstAnswer]) {
            [self optionClick:optionBtn];
            break;
        }
    }
    
    //substract score
    [self addScore:-1000];
    
    
    
}

- (IBAction)bigImg {
    //1.add shadow
    UIButton *cover = [[UIButton alloc]init];
    cover.frame = self.view.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(smallImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    self.cover = cover;
    
    self.iconX = self.iconBtn.frame.origin.x;
    self.iconY = self.iconBtn.frame.origin.y;
    self.iconW = self.iconBtn.frame.size.width;
    self.iconH = self.iconBtn.frame.size.height;
    //2. change the locations of shadow and avatar
    [self.view bringSubviewToFront:self.iconBtn];
    [UIView animateWithDuration:1.0 animations:^{
        cover.alpha = 0.7;
        //[UIView beginAnimations:nil context:nil];
        //[UIView setAnimationDuration:1.0];
        
        
        //3. change the avatar frame
        CGFloat iconW = self.view.frame.size.width;
        CGFloat iconH = iconW;
        CGFloat iconY = (self.view.frame.size.height - iconH) * 0.5;
        
        self.iconBtn.frame = CGRectMake(0, iconY, iconW, iconH);
       
    }];
    
    
 
   // [UIView commitAnimations];
    
}

- (IBAction)nextQuestion {
   
    if (self.index == self.questions.count - 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congratulation" message:@"pass!" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        [alert show];
        return;
    }
    
    //1.increase index
    self.index++;
    //2.get model
    Question *question = self.questions[self.index];
   
    
    
   
    [self settingData:question];
    
    [self addAnswerBtn:question];
    
    [self addOptionBtn:question];
  
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


-(void)settingData:(Question *)question
{
    //2.set the data of controller
    //1. set number
    self.noLabel.text = [NSString stringWithFormat:@"%d/%lu",self.index + 1,(unsigned long)self.questions.count];
    
    //2.set title
    self.titleLabel.text = question.title;
    
    
    //set image of button
    [self.iconBtn setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    
    self.nextBtn.enabled = self.index != (self.questions.count-1);
    
}

-(void)addOptionBtn:(Question *)question
{
    self.optionView.userInteractionEnabled = YES;
    for (UIView *subview in self.optionView.subviews) {
        [subview removeFromSuperview];
    }
    
    int count =question.options.count;
    for (int i = 0; i < count; i++) {
        UIButton *optionBtn = [[UIButton alloc]init];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        
        CGFloat optionW = 35;
        CGFloat optionH = 35;
        CGFloat margin = 10;
        
        CGFloat viewW = self.view.frame.size.width;
        
        int totalColumn = 6;
        CGFloat leftMargin = (viewW - totalColumn * optionW - margin * (totalColumn - 1)) * 0.5 ;
        
        int col = i % totalColumn;
        CGFloat optionX =   leftMargin + (optionW + margin) * col;
        int row = i / totalColumn;
        
        CGFloat optionY = (optionH + margin) * row;
        
        optionBtn.frame = CGRectMake(optionX, optionY, optionW, optionH);
        
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.optionView addSubview:optionBtn];
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
}


-(void)optionClick:(UIButton *)optionBtn
{
    optionBtn.hidden = YES;
    
    for (UIButton *answerBtn in self.answerView.subviews) {
         NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        
        if (answerTitle.length == 0) {
            NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
            [answerBtn setTitle:optionTitle forState:UIControlStateNormal];
            
            break;
        }
    }
    
    
    BOOL full = YES;
    NSMutableString *tempAnswerTitle = [NSMutableString string];
    for (UIButton *answerBtn in self.answerView.subviews) {
        NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
        if (answerTitle.length  == 0) {
            full = NO;
        }
         if(answerTitle){
            [tempAnswerTitle  appendString:answerTitle];
         }
    }
    
    if (full) {
        
        self.optionView.userInteractionEnabled = NO;
        
        Question *question = self.questions[self.index];
        if ([tempAnswerTitle isEqualToString:question.answer]) {
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            [self addScore:1000];
            
        //after 1 second enter to next question
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
        }else{
            for (UIButton *answerBtn in self.answerView.subviews) {
                [answerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    
}

-(void)addAnswerBtn:(Question *)question
{
//    for (UIView *subview in self.answerView.subviews) {
//        [subview removeFromSuperview];
//    }
    
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    int length = question.answer.length;
    for (int i = 0; i < length; i++) {
        UIButton *answerBtn = [[UIButton alloc]init];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        CGFloat margin = 10;
        
        CGFloat answerW = 35;
        CGFloat answerH = 35;
        
        CGFloat viewW = self.view.frame.size.width;
        
        CGFloat leftMargin = (viewW - length * answerW- margin * (length - 1))  * 0.5;
        
        
        CGFloat answerX = leftMargin + (margin + answerW) * i;
        
        answerBtn.frame = CGRectMake(answerX, 0, answerW, answerH);
        [self.answerView addSubview:answerBtn];
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)answerClick:(UIButton *)answerBtn
{

    self.optionView.userInteractionEnabled = YES;
//    for (UIButton *optionBtn in self.optionView.subviews) {
//        optionBtn.enabled = YES;
//    }
    
    
    //NSString *answerTitle = [answerBtn titleForState:UIControlStateNormal];
    NSString *answerTitle = answerBtn.currentTitle;
    for (UIButton *optionBtn in self.optionView.subviews) {
        
        
        //NSString *optionTitle = [optionBtn titleForState:UIControlStateNormal];
        NSString *optionTitle = optionBtn.currentTitle;
        
        if ([optionTitle isEqualToString:answerTitle] && optionBtn.hidden == YES) {
            optionBtn.hidden = NO;
            
            break;
        }
        
    }
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    
    for (UIButton *answerBtn in self.answerView.subviews) {
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

-(void)smallImg
{

    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(removeCover)];
    
    
    
    
    [UIView animateWithDuration:1.0 animations:^{
        self.iconBtn.frame = CGRectMake(self.iconX, self.iconY, self.iconW, self.iconH);
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
               [self.cover removeFromSuperview];
                self.cover = nil;
    }];
    
   // [UIView commitAnimations];
    
    
    
}

//-(void)removeCover
//{
//        [self.cover removeFromSuperview];
//        self.cover = nil;
//}

- (IBAction)help {
}

- (IBAction)iconClick {
    if (self.cover == nil) {
        [self bigImg];
    }else{
        [self smallImg];
    
    }
    
    
}
@end
