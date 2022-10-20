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

    uint256 public index;

    mapping(uint256 => address) public indexAddress;

    
    //构造一个管理员 合约创建者
    constructor()public{
        _owner =payable(msg.sender);
    }


    // 马蹄莲批量mint  
    function mintmxen() public {
        //批量创建合约
        for(uint i=0;i<20;i++){
            address cAddress = createActive();
            indexAddress[index] = cAddress;
            index = index + 1;
        }
        
    }

    // 批量提取子合约 Mxen
    function claimXEN() public{
        require(msg.sender == _owner ,"not owner !");
        for(uint i = 0;i< index;i++){
            address stakaddress = indexAddress[i];
            IXenActive(stakaddress).rewardTransfer();
        } 
    }

    //创建子合约
    function createActive() private returns(address) {
        XenActive xa = new XenActive();
        return address(xa);
    }

}