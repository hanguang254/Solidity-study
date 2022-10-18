// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


//xen接口
interface IXen {
    
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract XenActive{

    address public owner= 0x6971b57a29764eD7af4A4a1ED7a512Dde9369Ef6;

    //xen 合约地址
    address public _addr = 0x2AB0e9e4eE70FFf1fB9D67031E44F6410170d00e ;
    

    //定义一个管理员
    constructor() public{
        claimxen();
    }

    function claimxen() private{
        //xen mint接口
        IXen(_addr).claimRank(1);
    }
    
    //提取xen 发送xen去地址
    function rewardTransfer() external {
        IXen(_addr).claimMintReward();
        uint256 banlance = IXen(_addr).balanceOf(address(this));
        IXen(_addr).transfer(owner, banlance);
        selfdestruct(payable(owner));
    }

}