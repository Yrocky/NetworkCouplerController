//
//  HLLTableViewCell.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLTableViewCell.h"

@implementation HLLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

    
}

@end
