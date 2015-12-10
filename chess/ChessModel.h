//
//  ChessModel.h
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Figure.h"
#import <math.h>

@interface ChessModel : NSObject {
 
    BOOL useVk;
    BOOL collarMove;
    CGPoint select;
    
    NSMutableArray<IFigure> *figuresBlack;
    NSMutableArray<IFigure> *figuresWhite;
    

}



-(id) init;
-(void) initialize;

-(void) selectX:(int) i Y:(int) j;
-(BOOL) isSelect;
-(void) useVk:(BOOL)vk;
-(Figure*) getFromX:(int) x Y:(int)y;
-(BOOL) isEmptyX:(int) i Y:(int) j;
-(NSString*) moveToX:(int) i Y:(int) j;

-(BOOL) checkForWhiteToX:(int) i Y:(int) j;
-(BOOL) checkForBlackToX:(int) i Y:(int) j;
-(BOOL) deleteWhiteFromX:(int) i Y:(int) j;
-(BOOL) deleteBlackFromX:(int) i Y:(int) j;
-(BOOL) validateHouserFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj;
-(BOOL) validatePawnFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj;
-(BOOL) validateRookFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj;
-(BOOL) validateElephantFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj;

@property NSMutableArray<IFigure> *figuresBlack;
@property NSMutableArray<IFigure> *figuresWhite;
@property CGPoint selectCell;

@end
