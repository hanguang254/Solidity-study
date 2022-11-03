// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./fmxenActive.sol";


interface IfmxenActive{
    function rewardTransfer() external;
}

//matic 批量mint  与提取mxen合约
contract fmxenFactory{
    // 声明地址管理员
    address public _owner;

    uint256 public index;

    mapping(uint256 => address) public indexAddress;

    
    //构造一个管理员 合约创建者
    constructor()public{
        _owner =payable(msg.sender);
    }


    // ftm莲批量mint  
    function mintmxen() public {
        uint256 ins = index;
        //批量创建合约
        for(uint i=0;i<20;i++){
            fmXenActive cAddress = new fmXenActive{salt: bytes32(i)}();
            indexAddress[ins] = address(cAddress);
            ins = ins + 1;
        }
        index=ins;
    }

    // 批量提取子合约 Mxen
    function claimXEN() public {
        require(msg.sender == _owner ,"not owner !");
        for(uint i = 0;i<index;i++){
            address stakaddress = indexAddress[i];
            fmXenActive(stakaddress).rewardTransfer();
        } 
    }

}