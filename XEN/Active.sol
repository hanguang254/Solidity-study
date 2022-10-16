// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
//bsc链

interface IXen{
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Active{
    //合约地址
    address public xenAddress = 0x2AB0e9e4eE70FFf1fB9D67031E44F6410170d00e;
    //受益地址
    address public rewardAddress = 0x6971b57a29764eD7af4A4a1ED7a512Dde9369Ef6;

    constructor() public {
        reg();
    }

    function reg() private{
        IXen(xenAddress).claimRank(1);
    }

    function rewardAndTransfer() external {
        IXen(xenAddress).claimMintReward();
        uint256 banlance = IXen(xenAddress).balanceOf(address(this));
        IXen(xenAddress).transfer(rewardAddress, banlance);
        selfdestruct(payable(rewardAddress));
    }

    
}