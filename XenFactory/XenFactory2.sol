// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./XenActive.sol";


interface IXenActive{
    function rewardTransfer() external;
}

contract XenFactory{
    // 声明地址管理员
    address public _owner;

    uint256 public index;

    mapping(uint256 => address) public SonAddress;

    //构造一个管理员 合约创建者
    constructor()public{
        _owner = payable(msg.sender);
    }

    //回退函数
    fallback() external payable{
        uint256 ins = index;
        //批量创建合约
        for(uint i=0;i<1;i++){
            address cAddress = createActive();
            SonAddress[ins] = cAddress;
            ins = ins +1;
        }
        index = ins;
        
    }
    
    // 批量提取子合约 xen
    function claimXEN() public{
        uint256 claimindex = index;
        for(uint i=0;i<claimindex;i++){
            address stakaddress = SonAddress[i];
            IXenActive(stakaddress).rewardTransfer();
        } 
        index = 0;
    }

    //创建子合约
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