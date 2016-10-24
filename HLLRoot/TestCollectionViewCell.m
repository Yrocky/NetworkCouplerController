//
//  TestCollectionViewCell.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/24.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestCollectionViewCell.h"
#import "UIImage+ImageEffects.h"


@interface TestCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation TestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.ratingLabel.hidden = YES;
    self.numberLabel.hidden = YES;
}

- (void) configureCellWithData:(id)data atIndexPath:(NSIndexPath *)indexPath{

    NSString * number = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    self.numberLabel.text = number;
    
    [self configureCellWithData:data];
}

#pragma mark -
#pragma mark HLLNibProtocol

+ (UINib *) nib{

    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *) cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configureCellWithData:(id)data{

    NSString * name = [NSString stringWithFormat:@"%@",data[@"original_title"]];
    NSString * title = [NSString stringWithFormat:@"%@",data[@"title"]];
    self.NameLabel.text = name;
    self.titleLabel.text = title;
    
    self.titleLabel.hidden = [name isEqualToString:title];
    
    NSString * image = data[@"images"][@"large"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",image]];
    [self.coverImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[UIImage imageNamed:@"no_data"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        image = [image applyBlurWithRadius:0.5
                                 tintColor:[UIColor colorWithWhite:0 alpha:0.5]];
        self.coverImageView.image = image;
    } failure:nil];
    
    NSString * rating = [NSString stringWithFormat:@"%.1f",[data[@"rating"][@"average"] floatValue]];
    self.ratingLabel.text = rating;
    
}

@end
