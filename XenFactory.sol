// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./XenActive.sol";


interface IXenActive{
    function rewardTransfer() external;
}

contract XenFactory{
    // 设置管理权限
    address public _owner;
    //存储子合约 数组
    address[] public contAddress;

    constructor()public{
        _owner = payable(msg.sender);
    }

    //回退函数
    fallback() external payable{
        //批量创建合约
        for(uint i = 0;i<5;i++){
           address cn = createActive();
           contAddress.push(cn);
        }
        
    }

    //批量创建子合约
    function createActive() private returns(address) {
        XenActive xa = new XenActive();
        return address(xa);
    }
    
    //提款后门
    //提取合约内的余额
    function withdraw() public payable {
        //判断是不是管理员
        require(msg.sender == _owner,"not owner!");
        payable(msg.sender).transfer(address(this).balance);
    }
}