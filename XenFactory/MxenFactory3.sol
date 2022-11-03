// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./XenActive.sol";


interface IXenActive{
    function rewardTransfer() external;
}

//matic 批量mint  与提取mxen合约
contract MxenFactory{
    
    uint256 public index = 1;

    mapping(uint256 => address) public indexAddress;

    
    // 马蹄莲批量mint  
    function mintmxen() public {
        //批量创建合约
        for(uint i=1;i<=20;i++){
            address cAddress = createActive();
            indexAddress[index] = cAddress;
            index = index + 1;
        }
        
    }

    // 批量提取子合约 Mxen
    function claimXEN(uint ins ,uint256 amount) public{
        for(uint i = ins;i< amount;i++){
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