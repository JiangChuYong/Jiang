//
//  ZZSpaceOnlineReserveSeartTableViewCell.m

//

#import "ZZSpaceOnlineReserveSeartTableViewCell.h"

@implementation ZZSpaceOnlineReserveSeartTableViewCell
- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.btnCheckBox setSelected:(!self.btnCheckBox.selected)];
    }
}
- (IBAction)clickCheckBox:(id)sender {
    [self.btnCheckBox setSelected:(!self.btnCheckBox.selected)];
    
}



//初始化属性
- (void)initCellProperty:(NSMutableArray *)cellModels index:(NSInteger)index name:(NSString *)name
{

    NSDictionary * cellInfo = cellModels[index];
    //空间单元编码
    self.labelRoomNum.text = cellInfo[@"CellCode"];
    
    NSDictionary * cellPrice = cellInfo[@"CellPrice"][0];
    self.labelPriceNum.text = [NSString stringWithFormat:@"￥%@",cellPrice[@"Amount"]];
    self.labelPeopleNum.text = [NSString stringWithFormat:@"%@",cellInfo[@"CellNum"]];
    
    
    int cellType = [cellInfo[@"SpaceCellType"] intValue];
    self.officeTypeLabel.text = [[CommonUtil sharedInstance] nameForSpaceType:cellType];
    if (cellType == 2 ||cellType == 3) {
        self.officePersonNum.text = @"人桌";
    }else{
        self.officePersonNum.text = @"人间";
    }
    
    if (cellType == 4) {
        self.unitLabel.text = @"／小时";
    }

}

@end
