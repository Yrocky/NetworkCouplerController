//
//  TestCollectionViewCell.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/24.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLNibProtocol.h"

@interface TestCollectionViewCell : UICollectionViewCell<HLLNibProtocol>

- (void) configureCellWithData:(id)data atIndexPath:(NSIndexPath *)idnexPath;
@end
