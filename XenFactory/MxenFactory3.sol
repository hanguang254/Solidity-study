// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./XenActive.sol";


interface IXenActive{
    function rewardTransfer() external;
}

//matic 批量mint  与提取mxen合约
contract MxenFactory{
    // 声明地址管理员
    address public _owner;
    //存储子合约 数组
    address[] public contAddress;

    //映射子合约地址
    mapping(uint256 => address) public SonAddress;

    //构造一个管理员 合约创建者
    constructor()public{
        _owner =payable(msg.sender);
    }


    // 马蹄莲批量mint  
    function mintmxen() public {
        //批量创建合约
        for(uint i=0;i<20;i++){
            address cAddress = createActive();
            SonAddress[i] = cAddress;
            contAddress.push(SonAddress[i]);
        }
        
    }

    // 批量提取子合约 Mxen
    function claimXEN() public{
        for(uint i = contAddress.length-1;i>=0;i--){
            address stakaddress = contAddress[i];
            IXenActive(stakaddress).rewardTransfer();
            contAddress.pop();
        } 
    }

    //创建子合约
    function createActive() private returns(address) {
        XenActive xa = new XenActive();
        return address(xa);
    }

}