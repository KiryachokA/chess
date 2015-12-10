//
//  GLGameView.h
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessModel.h"

@interface GameView : UIView {
    ChessModel* model;
    
    CGImageRef blackRect;
    CGImageRef whiteRect;
}
@property BOOL isSelected;



- (NSString*) selectCellX:(int) x Y:(int) y;
- (void) drawRect:(CGRect)rect;
- (void) drawBoard:(int) frameSize;

@end
