//
//  PayOrderModel.h

//

//  订单确认 request

#import <Foundation/Foundation.h>

@interface PayOrderModel : NSObject

/** *订单编号*/
@property (nonatomic, strong) NSString * OrderId;
/** *账单总金额（未扣除折扣金额）*/
@property (nonatomic, assign) float Amount;
/** *优惠券编号*/
@property (nonatomic, strong) NSString * DiscountCode;
/** *优惠金额*/
@property (nonatomic, assign) float DiscountAmount;

/** *是否需要发票（0：不开,1：开发票）*/
@property (nonatomic, assign) int BeedInvoice;

/** *支付方式编号 与bill相关的账单编号*/
@property (nonatomic, assign) NSString * PayAccountId;

/** *是否线下支付 0是线上支付  1是线下支付 */
@property (nonatomic, assign) int IsPayOffline;


@end
