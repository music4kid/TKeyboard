//
//  KeyboardHolder.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "KeyboardHolder.h"
#import "MBProgressHUD.h"
#import "KeyboardAdapter.h"
#import "PAnimatedLabel.h"
#import "EmojiMap.h"
#import "NumberHolder.h"



@interface KeyboardHolder ()<NumberHolderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnGlobal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btnSync;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet PAnimatedLabel *lbInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnBluetooth;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;
@property (weak, nonatomic) IBOutlet UIScrollView *emojiHolder;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;


@property (weak, nonatomic) IBOutlet UIButton *btnNumber;
@property (weak, nonatomic) IBOutlet NumberHolder *numberHolder;


@property (nonatomic, strong) NSMutableArray*              emojiArr;

@property (nonatomic, strong) KeyboardAdapter*             adapter;

@end

@implementation KeyboardHolder

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initHolderView:(EAdapter*)adapter {
    
    self.adapter = (KeyboardAdapter*)adapter;
    _tableView.delegate = _adapter;
    _tableView.dataSource = _adapter;
    
    [_loading stopAnimating];
    _loading.hidden = true;
    
    [self.btnGlobal addTarget:self.controller action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventAllTouchEvents];
    [self.btnSync addTarget:self action:@selector(btnSyncClick) forControlEvents:UIControlEventTouchUpInside];
    
    _topLine.backgroundColor = [UIColor colorWithHex:0x888888];
    _topLine.layer.shadowOffset = CGSizeMake(0, 0.5);
    _topLine.layer.shadowOpacity = 1.0;
    _topLine.layer.shadowColor = [UIColor colorWithHex:0x000000].CGColor;
    _topLine.layer.masksToBounds = false;
    _topLine.alpha = 0.8;
    
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _bottomLine.layer.masksToBounds = false;
    _bottomLine.layer.shadowOffset = CGSizeMake(0, -0.5);
    _bottomLine.layer.shadowOpacity = 1.0;
    _bottomLine.layer.shadowColor = [UIColor colorWithHex:0x000000].CGColor;
    _bottomLine.layer.masksToBounds = false;
    _bottomLine.alpha = 0.5;
    
    self.lbInfo.textAlignment = NSTextAlignmentRight;
    _lbInfo.backgroundColor = [UIColor clearColor];
    _lbInfo.textColor = [UIColor colorWithHex:0x555555];
    _lbInfo.text = @"";
    _lbInfo.font = [UIFont systemFontOfSize:13];
    _lbInfo.alpha = 0;
    
    _btnSync.hidden = true;
    
    _emojiHolder.hidden = true;
    [self buildEmojiHolder];
    
    [_btnEmoji addTarget:self action:@selector(btnEmojiClick) forControlEvents:UIControlEventTouchUpInside];
    _btnEmoji.layer.cornerRadius = 4;
    _btnEmoji.layer.masksToBounds = true;
    [_btnEmoji setTitle:@"🙂" forState:UIControlStateNormal];
    
    [_btnBluetooth addTarget:self action:@selector(btnBluetoothClick) forControlEvents:UIControlEventTouchUpInside];
    _btnBluetooth.layer.cornerRadius = 4;
    _btnBluetooth.layer.masksToBounds = true;
    [_btnBluetooth setTitle:NSLocalizedString(@"txtBluetooth", nil) forState:UIControlStateNormal];
    
    _btnNumber.layer.cornerRadius = 4;
    _btnNumber.layer.masksToBounds = true;
    
    [self btnBluetoothClick];
    
    [_btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDelete setTitle:@"" forState:UIControlStateNormal];
    
    _numberHolder.delegate = self;
}

- (void)btnSyncClick
{
    if (self.delegate) {
        [_delegate onSyncClick];
    }
}

- (void)startLoading {
//    _loading.hidden = false;
//    [_loading startAnimating];
    
    [_lbInfo showText:NSLocalizedString(@"Searching", @"")];
}

- (void)stopLoading {
//    _loading.hidden = true;
//    [_loading stopAnimating];
    
    [_lbInfo showText:@""];
}

- (void)refreshHolderView {
    [_tableView reloadData];
}


- (void)showKeyboardInfo:(NSString*)str {
    [_lbInfo showText:str];
}
- (void)showKeyboardInfo:(NSString*)str autoHide:(BOOL)hide {
    [_lbInfo showText:str autoHide:hide];
}

- (void)buildEmojiHolder
{
    NSMutableArray* emojiSource = @[].mutableCopy;
    initEmoji(emojiSource);
    self.emojiArr = [NSMutableArray new];
    for (NSArray* arr in emojiSource) {
        [_emojiArr addObjectsFromArray:arr];
    }
    
    
    int emojiWidth = 48;
    int emojiHeight = 48;
    int minGap = 5;
    int perLine = SCREEN_WIDTH/(emojiWidth+minGap);
    int gap = (SCREEN_WIDTH - emojiWidth*perLine)/(perLine+1);
    
    int marginX = gap;
    int marginY = gap;
    
    UIButton* lastBtn;
    for (int i = 0; i < _emojiArr.count; i ++) {
        NSString* emoji = _emojiArr[i];
        
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:emoji forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_emojiHolder addSubview:btn];
        btn.frame = CGRectMake(marginX, marginY, emojiWidth, emojiHeight);
        
        marginX += (emojiWidth + gap);
        if ((i+1)%perLine == 0) {
            marginX = gap;
            
            marginY += (emojiHeight + gap);
        }
        
        if (i == _emojiArr.count-1) {
            lastBtn = btn;
        }
    }
    
    CGSize size = _emojiHolder.frame.size;
    size.height = lastBtn.frame.origin.y + lastBtn.frame.size.height + gap;
    _emojiHolder.contentSize = size;
}

- (void)emojiClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag;
    NSString* emoji = _emojiArr[index];
    
    if (self.delegate) {
        [_delegate onTextInsert:emoji];
    }
}

- (void)btnDeleteClick:(id)sender
{
    if (self.delegate) {
        [_delegate onDelete];
    }
}

- (void)btnBluetoothClick
{
    _tableView.hidden = false;
    _emojiHolder.hidden = true;
    _numberHolder.hidden = true;
    
    _btnEmoji.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _btnNumber.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _btnBluetooth.backgroundColor = [UIColor colorWithHex:0x333333];
}

- (void)btnEmojiClick
{
    _tableView.hidden = true;
    _emojiHolder.hidden = false;
    _numberHolder.hidden = true;
    
    _btnBluetooth.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _btnNumber.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _btnEmoji.backgroundColor = [UIColor colorWithHex:0x333333];
}

- (IBAction)btnNumberClick:(id)sender {
    _tableView.hidden = true;
    _emojiHolder.hidden = true;
    _numberHolder.hidden = false;
    
    _btnBluetooth.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    _btnNumber.backgroundColor = [UIColor colorWithHex:0x333333];
    _btnEmoji.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
}

- (void)onNumberInput:(NSString*)txt {
    if (self.delegate) {
        [_delegate onTextInsert:txt];
    }
}

- (void)onNumberDeleteClick {
    if (self.delegate) {
        [_delegate onDelete];
    }
}




@end
