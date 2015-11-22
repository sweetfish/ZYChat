//
//  GJGCChatFriendPostMessageCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-12-11.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendPostMessageCell.h"

@interface GJGCChatFriendPostMessageCell ()

@property (nonatomic,strong)GJCFCoreTextContentView *titleLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@end

@implementation GJGCChatFriendPostMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.blankImageView.gjcf_size = CGSizeMake(75-12,75-12);

        self.contentInnerMargin = 11.f;
        CGFloat bubbleToBordMargin = 56;
        CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin;
        
        self.titleLabel = [[GJCFCoreTextContentView alloc]init];
        self.titleLabel.gjcf_width = maxTextContentWidth;
        self.titleLabel.gjcf_height = 23;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.contentBaseWidth = self.titleLabel.gjcf_width;
        self.titleLabel.contentBaseHeight = self.titleLabel.gjcf_height;
        self.titleLabel.gjcf_left = self.contentBordMargin;
        [self.bubbleBackImageView addSubview:self.titleLabel];

        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        tapR.numberOfTapsRequired = 1;
        [self.bubbleBackImageView addGestureRecognizer:tapR];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnPost:)]) {
     
        [self.delegate chatCellDidTapOnPost:self];
    }
}

- (void)resetState
{
    self.contentImageView.gjcf_size = CGSizeMake(75, 75);
    self.blankImageView.gjcf_size = CGSizeMake(75-12,75-12);
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.progressView.gjcf_size = self.contentImageView.gjcf_size;
}

- (void)removePrepareState
{
    [super removePrepareState];
    
    self.contentImageView.gjcf_size = CGSizeMake(75, 75);
    self.blankImageView.gjcf_size = CGSizeMake(75-12,75-12);
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    self.progressView.gjcf_size = self.contentImageView.gjcf_size;

}

- (void)successDownloadWithImageData:(NSData *)imageData
{
    [super successDownloadWithImageData:imageData];
    
    [self removePrepareState];
    
    /* 重设图片大小 */
    CGSize imgRealSize = CGSizeMake(60, 60);
    if (CGSizeEqualToSize(CGSizeZero, imgRealSize)) {
        imgRealSize = CGSizeMake(75, 75);
    }
    
    CGFloat smallHeight;
    if (imgRealSize.width != 0) {
        
        smallHeight = imgRealSize.height * 75 / imgRealSize.width;
        
    }else{
        
        smallHeight = 75;
    }
    
    self.contentImageView.gjcf_size = CGSizeMake(75, smallHeight);
}

- (void)faildState
{
    self.contentImageView.image = GJCFImageStrecth([UIImage imageNamed:@"IM聊天页-占位图-BG.png"], 2, 2);
    self.blankImageView.hidden = NO;
    self.progressView.progress = 0.f;
    self.progressView.hidden = YES;

    self.progressView.gjcf_size = self.contentImageView.gjcf_size;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    [super setContentModel:contentModel];
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = chatContentModel.isFromSelf;
    
    [self resetState];

    /* 重设图片大小 */
    CGSize imgRealSize = CGSizeMake(60, 60);
    if (CGSizeEqualToSize(CGSizeZero, imgRealSize)) {
        imgRealSize = CGSizeMake(75, 75);
    }
    
    CGFloat smallHeight;
    if (imgRealSize.width != 0) {
        
        smallHeight = imgRealSize.height * 75 / imgRealSize.width;

    }else{
        
        smallHeight = 75;
    }
    
    self.contentImageView.gjcf_size = CGSizeMake(75, smallHeight);
    self.progressView.gjcf_size = self.contentImageView.gjcf_size;

    if (contentModel.contentSize.height > 0) {
        self.titleLabel.gjcf_size = contentModel.contentSize;
        self.contentSize = contentModel.contentSize;
    }else{
        CGSize theContentSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:chatContentModel.postAttributedTitle forBaseContentSize:self.titleLabel.contentBaseSize];
        self.titleLabel.gjcf_size = theContentSize;
        self.contentSize = theContentSize;
    }
    
    self.titleLabel.gjcf_top = self.contentInnerMargin;
    if (chatContentModel.isFromSelf) {
        self.titleLabel.gjcf_left = self.contentInnerMargin;
        self.contentImageView.gjcf_left = self.contentInnerMargin;

    }else{
        self.titleLabel.gjcf_left = self.contentInnerMargin + 5.5;
        self.contentImageView.gjcf_left = self.contentInnerMargin + 5.5;
    }
    self.titleLabel.contentAttributedString = chatContentModel.postAttributedTitle;
    self.contentImageView.gjcf_top = self.titleLabel.gjcf_bottom + 5;
    
    /* 当图片和默认图大小不一致的时候需要处理一下 */
    if (!CGSizeEqualToSize(CGSizeZero, imgRealSize)) {
        
        CGFloat blankWidth = 75 - 12;
        
        if (self.contentImageView.gjcf_height > self.contentImageView.gjcf_width) {
            
            CGFloat scale = self.contentImageView.gjcf_width / self.contentImageView.gjcf_height;
            
            blankWidth = 75 * scale - 12;
            
        }else{
            
            CGFloat scale = self.contentImageView.gjcf_height / self.contentImageView.gjcf_width;
            
            blankWidth = 75 * scale - 12;
        }
        
        self.blankImageView.gjcf_size = CGSizeMake(blankWidth, blankWidth);
    }
    self.blankImageView.gjcf_centerX = self.contentImageView.gjcf_width/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    
    
    /* 重设气泡 */
    self.bubbleBackImageView.gjcf_height = self.contentImageView.gjcf_bottom + self.contentInnerMargin;
    
    CGFloat maxWidth = MAX(self.titleLabel.gjcf_width, self.contentImageView.gjcf_width);
    self.bubbleBackImageView.gjcf_width = maxWidth + 2*self.contentBordMargin;
    
    [self adjustContent];
    
}

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(favoritePost:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    NSArray *menuItems = @[item1,item2];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    
    [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
    [popMenu setMenuVisible:YES animated:YES];

}

- (void)favoritePost:(UIMenuItem *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidChooseFavoritePost:)]) {
        [self.delegate chatCellDidChooseFavoritePost:self];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(favoritePost:) || action == @selector(deleteMessage:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

@end
