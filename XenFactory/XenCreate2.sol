// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./XenCreateActive.sol";


interface IXenCreateActive{
    function rewardTransfer() external;
}

//matic 批量mint  与提取mxen合约
contract MxenCreateFactory{
    uint public index = 1;
    mapping(uint256 => address) public indextoaddres;



    function createFactory()external{
        for(uint j = 0;j<100;j++){
            claim();
        }
    }
        
    function claim() private{
            uint _salt = index;
            XenCreateActive cn = new XenCreateActive{salt:bytes32(_salt)}();
            indextoaddres[index]= address(cn);
            index = index +1;
    }

    // 批量提取子合约 Mxen
    function claimXEN() public{
        for(uint i=1;i<index;i++){
            address cn = indextoaddres[i];
            IXenCreateActive(address(cn)).rewardTransfer();
        }
         
    }

}