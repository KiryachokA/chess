//
//  GLGameView.m
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.
//

#import "GameView.h"

@implementation GameView
@synthesize isSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    model = [[ChessModel alloc] init];
    
    NSString *filename = [[NSString alloc] initWithFormat:@"black.png"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    blackRect=CGImageRetain(img.CGImage);
    
    NSString *filename2 = [[NSString alloc] initWithFormat:@"white.jpg"];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:filename2 ofType:nil];
    UIImage *img2 = [UIImage imageWithContentsOfFile:imagePath2];
    whiteRect = CGImageRetain(img2.CGImage);
}

-(void) drawBoard:(int) frameSize {
    CGRect imageRect;
    imageRect.size = CGSizeMake(frameSize, frameSize);
    CGContextRef context=UIGraphicsGetCurrentContext();
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            imageRect.origin = CGPointMake(frameSize*j, frameSize*i);
            if ((i + j) % 2 == 0) {
                CGContextDrawImage(context, imageRect, whiteRect);
            }
            else {
                CGContextDrawImage(context, imageRect, blackRect);
            }
        }
    }
    
    for (int i =0; i <[model.figuresBlack count]; i++) {
        CGPoint p = [[model.figuresBlack objectAtIndex:i] getPosition];
        NSLog(@"figuresBlack %d , %f, %f", i, p.x, p.y);
        [[model.figuresBlack objectAtIndex:i] draw: frameSize];
        
    }
    for (int i =0; i <[model.figuresWhite count]; i++) {
        CGPoint p = [[model.figuresWhite objectAtIndex:i] getPosition];
        NSLog(@"figuresWhite %d , %f, %f", i, p.x, p.y);
        [[model.figuresWhite objectAtIndex:i] draw: frameSize];
    }
    
    if([model isSelect]){
        CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
        CGContextStrokeRect (context, CGRectMake(model.selectCell.y * frameSize,
                                                 model.selectCell.x * frameSize,
                                                 frameSize, frameSize) );
    }
}

- (void)drawRect:(CGRect)rect //отрисовка
{
     if(model == nil)
        [self initialize];
    
    [self drawBoard: self.frame.size.height/8];
}


-(NSString*) selectCellX:(int) x Y:(int) y {
    NSString *fail = @"fail";
    NSString *step;
    BOOL empty = [model isEmptyX:x Y:y];
   
    if(empty && ![model isSelect]) {
       //zvyk
    }
    if ([model isSelect]) {   // ход в поле
        step = [model moveToX:x Y:y];
        if (![step isEqualToString:@"fail"]) {
            return step;
        }
        else return fail;
    }
    if(!empty && ![model isSelect]) { // выделяем фигуру
        [model selectX:x Y:y];
    }
    return fail;
    
}



@end
