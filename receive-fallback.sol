// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//接受

contract ab{


    event fallbackCalled(address Sender, uint Value,bytes data);
    
    // 定义事件
    event Received(address Sender, uint Value);

    // 接收ETH时释放Received事件
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // fallback
    fallback() external payable{
        emit fallbackCalled(msg.sender, msg.value, msg.data);
    }
    //获取余额合约内的余额函数
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // 提取合约内的余额
    function withdraw(address payable _address) public {
        _address.transfer(address(this).balance);
    }
    
}