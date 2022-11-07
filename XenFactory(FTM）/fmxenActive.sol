// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


//xen接口
interface IfmXen {
    
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract fmXenActive{
    //受益者地址
    address public owner= 0x6971b57a29764eD7af4A4a1ED7a512Dde9369Ef6;

    //xen 合约地址
    address public _addr = 0xeF4B763385838FfFc708000f884026B8c0434275 ;
    

    //构造函数
    constructor() public{
        claimxen();
    }

    function claimxen() private{
        //xen mint接口
        IfmXen(_addr).claimRank(5);
    }
    
    //提取xen 发送xen去地址
    function rewardTransfer() external {
        IfmXen(_addr).claimMintReward();
        uint256 banlance = IfmXen(_addr).balanceOf(address(this));
        IfmXen(_addr).transfer(owner, banlance);
        selfdestruct(payable(owner));
    }

}