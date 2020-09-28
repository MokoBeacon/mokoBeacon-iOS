/*
 头文件说明：
 1、所有app里定义的枚举类型
 */

/**
 模式页面的cell状态
 */
typedef NS_ENUM(NSInteger, HCKModeCellStatus) {
    HCKModeCellStatusNormal,        //正常状态，未被选中，开始按钮可点击，停止按钮不可点击
    HCKModeCellStatusSelected,      //被选中状态(点击了开始按钮)，开始按钮不可点击，停止按钮可点击，并且背景色为黄色
    HCKModeCellStatusUnSelected,    //未选中状态，(其他cell被点击了开始按钮)，开始和停止按钮都不可点击
};
